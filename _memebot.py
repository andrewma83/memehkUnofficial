#!/usr/bin/python
# Created by:	Andrew Ma
# Data:		11/28/2013
# All Right Reserved	

import urllib
import os
import re
import MySQLdb
from HTMLParser import HTMLParser


db = ""
cursor = ""
# create a subclass and override the handler methods
class MyHTMLParser(HTMLParser):
    onclick = ""
    href = ""
    title = ""
    episode_no = ""
    part = ""
    readyTitle = 0
    episodeTitle = 0
    episode = 0
    part = 0
    id = 0;
    def handle_starttag(self, tag, attrs):
	self.readyTitle = 0
	if (tag == "h3"):
	    for name, value in attrs:
	    	if (name == "class" and value == "title"):
		    self.readyTitle = 1
		    self.onclick = ""
		    self.href = ""
		    self.title = ""
		    self.part = self.part + 1
		    break

	if (tag == "h1"):
	    for name, value in attrs:
	    	if (name == "class" and value == "title"):
		    self.episodeTitle = 1
		    self.onclick = ""
		    self.href = ""
		    self.title = ""
		    self.part = 0;
		    break


	if (tag == "a"):
	    for name, value in attrs:
	    	if (name == "href"):
		    self.href = value
		elif (name == "onclick"):
		    value = re.sub('jsCapTraffic\(\'[ ]*', '', value);
		    value = re.sub('[ ]+', '', value);
		    value = re.sub('[\')]', '', value);
		    value = re.sub(',', ' ', value);

		    pattern = ur"[^ ]+[ ]+usdl"
		    if (re.match(pattern, value)):
		    	self.onclick = value
			self.href = ""
		    else:
		     	self.onclick = ""


		if (self.onclick != "" and self.href != ""):
#		    print "    ", self.title, ":", self.href, ":", self.part, ":", self.id
		    sql = "INSERT INTO program (id, episode, title, mp3_url, part) VALUES (%d, %d, '%s', '%s', %d);"\
			   % (int(self.id), int(self.episode_no), self.title, self.href, self.part)
		    
		    try :
			cursor.execute(sql)
			db.commit()
		    except:
#		    	print "Need to rollback"
		    	db.rollback()
			break

		    self.onclick = ""
		    self.href = ""


    def handle_data(self, data):
	if (self.readyTitle == 1):
	    self.title = data
	    self.readyTitle = 0
	if (self.episodeTitle == 1):
	    pattern = ur"[ ]*[^ ]+[ ]+[^0-9]+([0-9]+)[^0-9]+"
	    self.episode_no = re.search(pattern, data).group(1)
#	    print "Expisode number: ", self.episode_no
	    self.episodeTitle = 0


def setup_db_conn ():
    global db
    global cursor
    db = MySQLdb.connect("localhost", "root", "xxxxxxx", "memehk")
    cursor = db.cursor()
    cursor.execute("set NAMES utf8;")
    db.commit()

def fetch_url (id):
    url = "http://www3.memehk.com/index.php?page=program&action=alist&id=%s" % id
    fd = urllib.urlopen(url)
    s = fd.read()
    return s


def parse_html (data, id):
    parser = MyHTMLParser()
    parser.id = id
    parser.feed(data)




def memebot(id):
    data = fetch_url(id)
    setup_db_conn()
    parse_html(data, id)
    db.close()



def main ():
    for i in range(1, 11):
	memebot(i) 


if __name__ == '__main__':
    main()

