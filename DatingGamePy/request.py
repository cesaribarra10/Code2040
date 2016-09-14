import requests
import json
from datetime import datetime, timedelta
import iso8601 as iso

headers = {
	'json':'Accept',
	'json':'Content-Type'
}

def make_network_request(url, data, headers):
	request = requests.post(url, data=data, headers=headers)
	return request

def parse_data_return_str(request):
	jsonReceived = json.loads(request.content)
	date = jsonReceived['datestamp']
	interval = jsonReceived['interval']
	parsed_date = iso.parse_date(date)
	date_with_interval = parsed_date + timedelta(seconds=interval)
	date_as_str = str(date_with_interval)
	fixed_string = date_as_str.replace('+00:00', 'Z')
	fixed_string = fixed_string.replace(' ', 'T')
	return fixed_string






dating_url = 'http://challenge.code2040.org/api/dating'
data_dictionary = {'token':'feb11791f036dc3f2ea5c1f39e41df63'}
get_request = make_network_request(dating_url, data=data_dictionary, headers=headers)
date_to_post = parse_data_return_str(get_request)
data_dictionary = {'token':'feb11791f036dc3f2ea5c1f39e41df63', 'datestamp':date_to_post}
validate_url = 'http://challenge.code2040.org/api/dating/validate'
post_request = make_network_request(validate_url, data=data_dictionary, headers=headers)
print(post_request.status_code)
