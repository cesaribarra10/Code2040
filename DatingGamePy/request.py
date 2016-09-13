import requests
import json
from datetime import datetime, timedelta
import iso8601 as iso

headers = {
	'json':'Accept',
	'json':'Content-Type'
}
r = requests.post('http://challenge.code2040.org/api/dating', data={'token':'feb11791f036dc3f2ea5c1f39e41df63'}, headers = headers)
if r.status_code == 200:
	token = "feb11791f036dc3f2ea5c1f39e41df63"
	print('The status code was 200')
	jsonReceived = json.loads(r.content)
	date = jsonReceived['datestamp']
	interval = jsonReceived['interval']
	print(date)
	print(interval)
	parsedDate = iso.parse_date(date)
	print(parsedDate)
	dateToPost = parsedDate + timedelta(seconds=interval)
	print(dateToPost)
	stringDate = str(dateToPost)
	strD = stringDate.replace('+00:00', 'Z')
	strSend = strD.replace(' ', 'T')
	print(strSend)
	dataToSend = {'token':token, 'datestamp':strSend}
	post = requests.post('http://challenge.code2040.org/api/dating/validate', data = dataToSend, headers = headers)
	print(post.status_code)