#!/usr/bin/env python3
# coding: utf-8

# Written by Roman Akchurin and Salavat Garifullin

import logging
import sys
# For the interaction with mongo and json files
import pymongo
import datetime
import json
from bson import json_util, objectid
# For the server
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qsl

# Very lame approach to handle command line args but using click here would be overkill
try:
    DEBUG = bool(int(sys.argv[1]))
except IndexError:
    DEBUG = False
logging_level = logging.DEBUG if DEBUG else logging.INFO
logging.basicConfig(level=logging_level, stream=sys.stdout)
log = logging.getLogger()
dprint = lambda *x: logging.debug(' '.join(map(str, x)))
iprint = lambda *x: logging.info(' '.join(map(str, x)))
eprint = lambda *x: logging.exception(' '.join(map(str, x)))
dprint('Debug printing on')


mongo_client = pymongo.MongoClient('localhost', 40000)
db = mongo_client.asl
accounts = db.accounts
sessions = db.sessions
legs = db.legs
oid = objectid.ObjectId


def get_phone_time(phone_id, verbose=False,
                   t=None, T=None, over_last=None):
    phone_id = int(phone_id)
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.utcnow()
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(int(T)//1000)
        t = datetime.datetime.utcfromtimestamp(int(t)//1000)
    findings = legs.find({'$or': [{'from_': phone_id}, {'to_': phone_id}], 
                          'created': {'$gte': (t - datetime.timedelta(hours=24))}, 
                          'created': {'$lte': T}, 'terminated': {'$gte': t}}, 
                         {'_id': 0, 'created': 1, 'terminated': 1, '_sid': 1})#.hint({'created': 1})    
    out = []
    for leg in findings:
        session = sessions.find_one({'_sid': leg['_sid']})
        if verbose:  # TODO: Isolate this part as it is repeated later
            all_legs = legs.find({'_sid': session['_sid']},
                                 {'_id': 0, '_lid': 1, 'created': 1, 'terminated': 1, 
                                  'updated': 1, 'from_': 1, 'to_': 1})
            finding = {'_sid': session['_sid'],
                       'created': session['created'],
                       'terminated': session['terminated'],
                       'updated': session['updated'],
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_'],
                       'legs': [leg for leg in all_legs]}
        else:
            finding = {'created': leg['created'].isoformat(), 
                       'terminated': leg['terminated'].isoformat(),
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_']}
        out.append(finding)
    dprint('findings:', out)
    return out


def get_phones_time(phone_ids=None, account_id=None, verbose=False,
                    t=None, T=None, over_last=None):
    # The function just wraps get_phone_time in order to make it work with lists of numbers
    if not any((phone_ids, account_id)):
        raise NameError('Missing phone/account ids')
    if account_id:
        #phone_ids = list(map(int, accounts.find_one({'_aid': int(account_id)})['phones']))
        phone_ids = list(map(int, accounts.find_one({'_aid': oid(account_id)})['phones']))
    else:
        phone_ids = list(map(int, phone_ids.split(',')))
    out = [get_phone_time(phone_id, verbose=verbose, t=t, T=T, over_last=over_last)
           for phone_id in phone_ids]
    dprint('findings:', out)
    return out


def get_phone_n(phone_id, n, verbose=False):
    phone_id = int(phone_id)
    n = int(n)
    findings = legs.find({'$or': [{'from_': phone_id}, {'to_': phone_id}]}).sort([('created', -1)]).limit(n)
    out = []
    for leg in findings:
        session = sessions.find_one({'_sid': leg['_sid']})
        if verbose:
            all_legs = legs.find({'_sid': session['_sid']},
                                 {'_id': 0, 'created': 1, 'terminated': 1, 'updated': 1, 'from_': 1, 'to_': 1})
            finding = {'_sid': session['_sid'],
                       'created': session['created'],
                       'terminated': session['terminated'],
                       'updated': session['updated'],
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_'],
                       'legs': [leg for leg in all_legs]}
        else:
            finding = {'created': leg['created'].isoformat(),
                       'terminated': leg['terminated'].isoformat(),
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_']}
        out.append(finding)
    dprint('findings:', out)
    return out


def get_time_only(t=None, T=None, over_last=None, verbose=False):
    if not (over_last or (t and T)):
        raise NameError('Time not specified')
    if over_last:
        T = datetime.datetime.utcnow()
        t = T - datetime.timedelta(hours=int(over_last))
    else:
        T = datetime.datetime.utcfromtimestamp(int(T)//1000)
        t = datetime.datetime.utcfromtimestamp(int(t)//1000)
    findings = legs.find({'created': {'$gte': t - datetime.timedelta(hours=24)},
                          'created': {'$lte': T},
                          'terminated': {'$gte': t}},
                         {'_id': 0, '_sid': 1, 'created': 1, 'terminated': 1})#.hint({'created': 1})
    out = []
    for leg in findings:
        session = sessions.find_one({'_sid': leg['_sid']})
        if verbose:
            all_legs = legs.find({'_sid': session['_sid']},
                                 {'_id': 0, 'created': 1, 'terminated': 1, 'updated': 1, 'from_': 1, 'to_': 1})
            finding = {'_sid': session['_sid'],
                       'created': session['created'],
                       'terminated': session['terminated'],
                       'updated': session['updated'],
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_'],
                       'legs': [leg for leg in all_legs]}
        else:
            finding = {'created': leg['created'].isoformat(),
                       'terminated': leg['terminated'].isoformat(),
                       'session_type': session['session_type'],
                       'from_': session['from_'],
                       'to_': session['to_']}
        out.append(finding)
    dprint('findings:', out)
    return out


def get_request(request_type=None, **kwargs):
    switch = {'phone_n'    : get_phone_n,
              'time_only'  : get_time_only,
              'phone_time' : get_phone_time,
              'phones_time': get_phones_time}
    try:
        handler = switch[request_type]
        result = handler(**kwargs)
        return 200, json.dumps(result, default=json_util.default)
    except KeyError as ex:
        return 400, 'Unknown request type\n' + str(ex)
    except NameError as ex:
        return 400, 'Invalid parameter\n' + str(ex)
    except TypeError as ex:
        return 400, 'Invalid keyword\n' + str(ex)


def shard_key(T):    
    #borders = [(1+1)*24, (14+1)*24, (31+1)*24, (4*31+1)*24]
    borders = get_borders()
    now = datetime.datetime.utcnow()
    shards = [now-br for br in borders]
    #shards = [now-datetime.timedelta(hours=br) for br in borders]
    key = 1 + sum([1 for sh in shards if T < sh])
    return key


def get_borders():
    borders = [(1+1), (14+1), (31+1), (4*31+1)]
    borders = [datetime.timedelta(days=br) for br in borders]
    return borders


def create_session(session_type, created, from_, to_, session_id=None):
    session_id = oid(session_id)  # Generates id if one not provided
    from_, to_ = int(from_), int(to_)
    sessions.insert_one({'_sid'        : session_id,
                         'session_type': session_type,
                         'created'     : created,
                         'updated'     : datetime.datetime.utcnow(),
                         'from_'       : from_,
                         'to_'         : to_})
    dprint('Session id:', session_id)
    return session_id


def create_leg(session_id, created, from_, to_, leg_id=None):
    session_id = oid(session_id)
    leg_id = oid(leg_id)
    from_, to_ = int(from_), int(to_)
    legs.insert_one({'_lid': leg_id,
                     '_sid': session_id,
                     'created': created,
                     'updated': datetime.datetime.utcnow(),
                     'from_': from_,
                     'to_': to_,
                     #'shkey': shard_key(created)})
                     'shkey': int(1)})
    dprint('Leg id:', leg_id)
    return leg_id


def update_session(session_id, terminated):
    id = sessions.find_one({'_sid': oid(session_id)})['_id']
    response = sessions.update_one({'_id': id},
                                   {
                                       '$set': {'terminated': terminated},
                                       '$currentDate': {'updated': True}
                                   }).modified_count
    dprint('Modified count:', response)
    return response


def update_leg(leg_id, terminated):
    id = legs.find_one({'_lid': oid(leg_id)})['_id']
    response = legs.update_one({'_id': id},
                               {
                                   '$set': {'terminated': terminated},
                                   '$currentDate': {'updated': True}
                               }).modified_count
    dprint('Modified count:', response)
    return response


def post_request(data):
    switch = {'create_session': create_session,
              'create_leg'    : create_leg,
              'update_session': update_session,
              'update_leg'    : update_leg}
    try:
        request_type = data.pop('request_type')
        handler = switch[request_type]
        return 201, handler(**data)
    except KeyError as ex:
        return 400, 'Unknown request type\n' + str(ex)


# Server itself

class MyRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            path = self.path
            query = urlparse(path).query
            qs = dict(parse_qsl(query))
            r_code, response = get_request(**qs)
            self.send_response(r_code)
            self.send_header('content-type', 'application/json')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            self.send_response_only(500)
            eprint(ex)
    
    def do_POST(self):
        try:
            length = int(self.headers['content-length'])
            rawdata = self.rfile.read(length)
            data = json_util.loads(str(rawdata, 'utf-8'))
            r_code, response = post_request(data)
            self.send_response(r_code)
            self.send_header('content-type', 'text/html')
            self.end_headers()
            self.flush_headers()
            self.wfile.write(bytes(str(response) + '\n', 'utf-8'))
        except Exception as ex:
            self.send_response_only(500)
            eprint(ex)


if __name__ == '__main__':
    serv = HTTPServer(("localhost", 3467), MyRequestHandler)
    iprint('Entering mainloop', serv.server_address)
    serv.serve_forever()
