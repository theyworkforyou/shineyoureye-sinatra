#!/usr/bin/env python

from collections import defaultdict
import csv
import json
import requests
import time

from os.path import dirname, exists, join

root_dir = dirname(__file__)

MAPIT_URL_TEMPLATE = 'http://nigeria.mapit.mysociety.org/area/{}'

mapping_filename = join(root_dir, 'mapit', 'mapit_to_ep_area_ids_mapping.csv')
fed_to_sta_filename = join(root_dir, 'mapit', 'fed_to_sta_area_ids_mapping.csv')

mapit_id_to_mapit_data = {}
for basename in ('mapit-FED.json', 'mapit-STA.json'):
    with open(join(root_dir, basename)) as f:
        all_mapit_data = json.load(f)
        for mapit_id, mapit_data in all_mapit_data.items():
            mapit_id_to_mapit_data[mapit_id] = mapit_data

mapit_id_to_ep_area_id = defaultdict(set)
ep_area_id_to_mapit_id = {}
mapit_fed_id_to_mapit_sta_id = {}

with open(fed_to_sta_filename) as f:
    reader = csv.reader(f)
    for mapit_fed_id, mapit_sta_id in reader:
        mapit_fed_id_to_mapit_sta_id[mapit_fed_id] = mapit_sta_id

with open(mapping_filename) as f:
    reader = csv.reader(f)
    for row in reader:
        # i've stuck some "comments" at the end of the file :)
        if row[0].startswith('#'):
            continue
        assert len(row) == 2
        mapit_id, ep_area_id = [c.decode('utf-8') for c in row]
        mapit_id_to_ep_area_id[mapit_id].add(ep_area_id)
        if ep_area_id in ep_area_id_to_mapit_id:
            raise Exception("ep_area_id {} appears multiple times".format(ep_area_id))
        ep_area_id_to_mapit_id[ep_area_id] = mapit_id

for mapit_id, ep_area_ids in mapit_id_to_ep_area_id.items():
    if len(ep_area_ids) > 1:
        print u"The MapIt ID {} had more than one EP area ID:".format(mapit_id)
        for ep_area_id in sorted(ep_area_ids):
            print "  ", ep_area_id

# Check that all the areas in both versions of the EP Popolo JSON
# are covered:

def get_area_data(popolo_filename):
    with open(popolo_filename) as f:
        data = json.load(f)
    return {
        a['id']: a
        for a in data['areas']
        if a['name'] != ', State'
    }

missing_ep_area_ids = defaultdict(set)
ep_area_id_to_name = {}
ep_popolo_files = (
    'ep-popolo-v1.0-old.json',
    'ep-popolo-v1.0.json',
    'ep-popolo-v1.0-newer.json')

for popolo_filename in ep_popolo_files:
    for real_ep_area_id, area_data in get_area_data(popolo_filename).items():
        ep_area_id_to_name[real_ep_area_id] = area_data['name']
        if real_ep_area_id not in ep_area_id_to_mapit_id:
            missing_ep_area_ids[real_ep_area_id].add(popolo_filename)

for real_ep_area_id, popolo_filenames in missing_ep_area_ids.items():
    print u"Couldn't find {0} (from {1}) in mapping".format(
        real_ep_area_id, ', '.join(popolo_filenames))

# See which MapIt FED IDs don't have something corresponding in EP:

for mapit_id, mapit_data in mapit_id_to_mapit_data.items():
    if mapit_data['type'] != 'FED':
        continue
    if mapit_id not in mapit_id_to_ep_area_id:
        mapit_sta_id = mapit_fed_id_to_mapit_sta_id[mapit_id]
        print "{0} (MapIt: {1}) in {2} couldn't be found in the EP data".format(
            mapit_data['name'],
            mapit_id,
            mapit_id_to_mapit_data[mapit_sta_id]['name'])

def get_mapit_data(area_id):
    mapit_url = MAPIT_URL_TEMPLATE.format(area_id)
    cached_filename = join(root_dir, 'mapit-data', '{}.json'.format(area_id))
    if exists(cached_filename):
        with open(cached_filename) as f:
            return json.load(f)
    # Avoid the rate limiting:
    time.sleep(2)
    fuller_mapit_data = requests.get(mapit_url).json()
    with open(cached_filename, 'w') as f:
        json.dump(fuller_mapit_data, f)
    return fuller_mapit_data

# Now produce a larger CSV file to check in a spreadsheet:

mapit_name_types = [u'gadm', u'poll_unit', u'atlas', u'old_mapit', u'pombola']

with open('extra-columns.csv', 'w') as f:
    headers = mapit_name_types + [
        'MapIt State Name',
        'MapIt Name',
        'MapIt ID',
        'EP area ID',
        'EP area name',
    ]
    writer = csv.DictWriter(f, fieldnames=headers)
    writer.writeheader()
    for ep_area_id, mapit_id in ep_area_id_to_mapit_id.items():
        if mapit_id not in mapit_id_to_mapit_data:
            print "MapIt ID {0} wasn't found in mapit_id_to_mapit_data".format(mapit_id)
            continue
        mapit_data = mapit_id_to_mapit_data[mapit_id]
        mapit_sta_id = mapit_fed_id_to_mapit_sta_id[mapit_id]
        row = {
            'MapIt State Name': mapit_id_to_mapit_data[mapit_sta_id]['name'].encode('utf-8'),
            'MapIt Name': mapit_data['name'],
            'MapIt ID': mapit_id,
            'EP area ID': ep_area_id.encode('utf-8'),
            'EP area name': ep_area_id_to_name.get(ep_area_id, '').encode('utf-8'),
        }
        fuller_mapit_data = get_mapit_data(mapit_id)
        # Find alternative names from MapIt:
        row.update({
            k: v[1].encode('utf-8')
            for k, v in fuller_mapit_data['all_names'].items()})
        mapit_all_names = fuller_mapit_data['all_names']
        writer.writerow(row)
