import codecs
import MySQLdb
import os
import re
import trac2rst

def trac2gollum(text):
    # convert trac2rst and extra's for gollum
    lines = text.replace('\r\n', '\n').split('\n')
    lines = trac2rst.trac2rst(lines, dialect='gollum')
    return '\n'.join(lines)

def save_file_to_git(filename, comment, author, author_email, date_time):
    os.system('git add %s' % filename)
    v = (date_time, comment, author, author_email, date_time)
    os.system('''GIT_COMMITTER_DATE="%s" git commit -m '%s' --author="%s <%s>" --date=%s''' % v)

if __name__ == '__main__':
    # mysql config
    host = '192.168.128.4'
    user,password  = 'trac','cart'
    db = 'trac_citylive'
    # extra
    default_mail_domain = 'citylive.be'
    trac_location = 'http://office.citylive.be/trac/citylive/'
    trac_user = 'gert.vangool'
    trac_password = 'M0biVi_!'

    connection = MySQLdb.connect(host, user, password, db)
    # get wiki pages
    c = connection.cursor()
    c.execute('SELECT name,time,author,text,comment FROM wiki ORDER BY time, version')

    for p in c.fetchall():
        name,time,author,text,comment = p
        f = open('%s.rst' % name, 'w')
        f.write(trac2gollum(text))
        f.close()
        save_file_to_git('%s.rst' % name,
                         comment or '-empty-',
                         author,
                         '%s@%s' % (author, default_mail_domain,),
                         time)

    # get wiki attachments
    c = connection.cursor()
    c.execute('SELECT id,filename,author,description,time FROM attachment WHERE type="wiki" ORDER BY time')

    for p in c.fetchall():
        id,filename,author,description,time = p
        os.system('wget %(trac_location)s/raw-attachment/wiki/%(id)s/%(filename)s -O %(filename)s --user=%(trac_user)s --password=%(trac_password)s' % locals())
        save_file_to_git(filename,
                         description or '-empty-',
                         author,
                         '%s@%s' % (author, default_mail_domain,),
                         time)
