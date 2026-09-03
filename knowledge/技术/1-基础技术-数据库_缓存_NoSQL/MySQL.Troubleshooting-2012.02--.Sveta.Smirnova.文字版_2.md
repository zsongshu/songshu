---
title: "-MySQL.Troubleshooting-2012.02--.Sveta.Smirnova.文字版"
source: "-MySQL.Troubleshooting-2012.02--.Sveta.Smirnova.文字版.pdf"
type: book
tags: ["book", "mysql"]
created: 2026-07-03
---

# -MySQL.Troubleshooting-2012.02--.Sveta.Smirnova.文字版

![[MySQL.Troubleshooting-2012.02--.Sveta.Smirnova.文字版-115d308d.pdf]]

## 内容

### Page 3

MySQL Troubleshooting
Sveta Smirnova
Beijing • Cambridge • Farnham • Köln • Sebastopol • Tokyo

### Page 4

MySQL Troubleshooting
by Sveta Smirnova
Copyright © 2012 Sveta Smirnova. All rights reserved.
Printed in the United States of America.
Published by O’Reilly Media, Inc., 1005 Gravenstein Highway North, Sebastopol, CA 95472.
O’Reilly books may be purchased for educational, business, or sales promotional use. Online editions
are also available for most titles (http://my.safaribooksonline.com). For more information, contact our
corporate/institutional sales department: (800) 998-9938 or corporate@oreilly.com.
Editor: Andy Oram
Production Editors: Jasmine Perez and Teresa Elsey
Copyeditor: Genevieve d’Entremont
Proofreader: Jasmine Perez
Indexer: Angela Howard
Cover Designer: Karen Montgomery
Interior Designer: David Futato
Illustrator: Robert Romano
February 2012:
First Edition. 
Revision History for the First Edition:
2012-02-03
First release
See http://oreilly.com/catalog/errata.csp?isbn=9781449312008 for release details.
Nutshell Handbook, the Nutshell Handbook logo, and the O’Reilly logo are registered trademarks of
O’Reilly Media, Inc. MySQL Troubleshooting, the image of a Malayan badger, and related trade dress
are trademarks of O’Reilly Media, Inc.
Many of the designations used by manufacturers and sellers to distinguish their products are claimed as
trademarks. Where those designations appear in this book, and O’Reilly Media, Inc., was aware of a
trademark claim, the designations have been printed in caps or initial caps.
While every precaution has been taken in the preparation of this book, the publisher and author assume
no responsibility for errors or omissions, or for damages resulting from the use of the information con-
tained herein.
ISBN: 978-1-449-31200-8
[LSI]
1328280258

### Page 5

Table of Contents
Foreword . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . vii
Preface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ix
1. Basics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
Incorrect Syntax
1
Wrong Results from a SELECT
5
When the Problem May Have Been a Previous Update
10
Getting Information About a Query
16
Tracing Back Errors in Data
19
Slow Queries
24
Tuning a Query with Information from EXPLAIN
24
Table Tuning and Indexes
30
When to Stop Optimizing
34
Effects of Options
35
Queries That Modify Data
36
No Silver Bullet
39
When the Server Does Not Answer
39
Issues with Solutions Specific to Storage Engines
44
MyISAM Corruption
45
InnoDB Corruption
47
Permission Issues
49
2. You Are Not Alone: Concurrency Issues . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
Locks and Transactions
54
Locks
54
Table Locks
55
Row Locks
57
Transactions
63
Hidden Queries
63
Deadlocks
69
iii

### Page 6

Implicit Commits
72
Metadata Locking
73
Metadata Locking Versus the Old Model
75
How Concurrency Affects Performance
76
Monitoring InnoDB Transactions for Concurrency Problems
77
Monitoring Other Resources for Concurrency Problems
78
Other Locking Issues
79
Replication and Concurrency
86
Statement-Based Replication Issues
87
Mixing Transactional and Nontransactional Tables
91
Issues on the Slave
93
Effectively Using MySQL Troubleshooting Tools
94
SHOW PROCESSLIST and the
INFORMATION_SCHEMA.PROCESSLIST Table
95
SHOW ENGINE INNODB STATUS and InnoDB Monitors
96
INFORMATION_SCHEMA Tables
99
PERFORMANCE_SCHEMA Tables
100
Log Files
102
3. Effects of Server Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 107
Service Options
108
Variables That Are Supposed to Change the Server Behavior
111
Options That Limit Hardware Resources
112
Using the --no-defaults Option
113
Performance Options
114
Haste Makes Waste
114
The SET Statement
115
How to Check Whether Changes Had an Effect
115
Descriptions of Variables
116
Options That Affect Server and Client Behavior
117
Performance-Related Options
132
Calculating Safe Values for Options
142
4. MySQL’s Environment . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 147
Physical Hardware Limits
147
RAM
147
Processors and Their Cores
149
Disk I/O
149
Network Bandwidth
151
Example of the Effect of Latencies
151
Operating System Limits
152
Effects of Other Software
153
iv | Table of Contents

### Page 7

5. Troubleshooting Replication . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
Displaying Slave Status
157
Problems with the I/O Thread
159
Problems with the SQL Thread
166
When Data Is Different on the Master and Slave
167
Circular Replication and Nonreplication Writes on the Slave
168
Incomplete or Altered SQL Statements
170
Different Errors on the Master and Slave
170
Configuration
171
When the Slave Lags Far Behind the Master
171
6. Troubleshooting Techniques and Tools . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 173
The Query
173
Slow Query Log
174
Tools That Can Be Customized
175
The MySQL Command-Line Interface
177
Effects of the Environment
181
Sandboxes
181
Errors and Logs
185
Error Information, Again
185
Crashes
186
Information-Gathering Tools
189
Information Schema
189
InnoDB Information Schema Tables
191
InnoDB Monitors
192
Performance Schema
201
SHOW [GLOBAL] STATUS
203
Localizing the Problem (Minimizing the Test Case)
205
General Steps to Take in Troubleshooting
206
Testing Methods
208
Try the Query in a Newer Version
209
Check for Known Bugs
209
Workarounds
210
Special Testing Tools
211
Benchmarking Tools
211
Gypsy
215
MySQL Test Framework
216
Maintenance Tools
218
7. Best Practices . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 221
Backups
221
Planning Backups
222
Types of Backups
222
Table of Contents | v

### Page 8

Tools
223
Gathering the Information You Need
224
What Does It All Mean?
225
Testing
225
Prevention
226
Privileges
226
Environment
226
Think About It!
227
Appendix: Information Resources . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 229
Index . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 233
vi | Table of Contents

### Page 9

Foreword
Solving a system problem can be one of the most frustrating experiences a systems
expert can encounter. Repair of the problem or the execution of the solution is typically
the easy part. Diagnosing the cause of the problem is the real challenge.
Experienced administrators have learned—some by doing and others by trial and
error—that the best way to solve a problem is to use a standardized process for defining
the problem, forming a list of possible causes, and then testing each until the solution
is found. This may sound naïve, but it generally works (although it is not sufficient for
specialized systems).
MySQL is a specialized, complex, mature, and powerful database system capable of
meeting the needs of a vast number of organizations. MySQL is also very easy to install
and configure. Indeed, most default installations do not need to be configured or tuned
at all. However, MySQL is also a system with many layers of functionality that can
sometimes go awry and produce a warning or error.
Sometimes the warning or error is specific enough (or has been seen and documented
enough) that a solution can be implemented immediately. Other times, and thankfully
infrequently, a problem is encountered that does not have a known solution or is spe-
cific to your application, database, or environment. Finding a solution for such a warn-
ing, error, or other problem with MySQL can be a daunting task.
When encountering such an issue, database professionals typically search various
resources looking for clues or at least documentation that describes a similar problem
and solution. Most will find that there are simply too many references to problems that
are somewhat similar or that contain suggested solutions that simply don’t work or
don’t apply to your situation.
A fine example of this is searching the Internet using the error message as search criteria.
More often than not, you will find all manner of hits, varying from archived email logs
to blogs and similar commentary that may or may not refer to the error message. This
often leads to a lot of wasted time and frustration. What is needed is a reference guide
for how to solve problems with MySQL.
vii

### Page 10

Not only does this book fulfill that need, it also establishes a protocol for solving
problems that can be applied to almost any system. The methods presented are well
structured, thorough, and repeatable. Combined with real-world examples, the text
becomes a watershed work that defines the proper way to diagnose and repair MySQL.
Sveta uses her firsthand experiences and in-depth knowledge of MySQL and diagnostic
skills to teach the reader fundamental skills to diagnose and repair almost any problem
you may encounter with MySQL—making this book a must have for any MySQL
professional.
I consider myself a MySQL expert, and while my skills are backed by much experience,
I won’t claim to know everything there is to know about MySQL. After reading this
book, I can say that I’ve broadened my skills even further. If a seasoned professional
like myself can benefit from reading this book, every MySQL user should read this
book. More to the point, it should be considered required reading for all MySQL
database administrators, consultants, and database developers.
—Dr. Charles Bell, Oracle Corporation,
Author of MySQL High Availability (O’Reilly)
and Expert MySQL (Apress)
viii | Foreword

### Page 11

Preface
I have worked since May 2006 as a principal technical support engineer in the Bugs
Verification Group of the MySQL Support Group for MySQL AB, then Sun, and finally
Oracle. During my daily job, I often see users who are stuck with a problem and have
no idea what to do next. Well-verified methods exist to find the cause of the problem
and fix it effectively, but they are hard to cull from the numerous information sources.
Hundreds of great books, blog posts, and web pages describe different parts of the
MySQL server in detail. But here’s where I see the difficulty: this information is organ-
ized in such a way as to explain how the MySQL server normally works, leaving out
methods that can identify failures and ill-posed behavior.
When combined, these information sources explain each and every aspect of MySQL
operation. But if you don’t know why your problem is occurring, you’ll probably miss
the cause among dozens of possibilities suggested by the documentation. Even if you
ask an expert what could be causing your problem, she can enumerate many suspects,
but you still need to find the right one. Otherwise, any changes you make could just
mask the real problem temporarily, or even make it worse.
It is very important to know the source of a problem, even when a change to an SQL
statement or configuration option can make it go away. Knowledge of the cause or
failure will arm you to overcome it permanently and prevent it from popping up again
in the future.
I wrote this book to give you the methods I use constantly to identify what caused an
error in an SQL application or a MySQL configuration and how to fix it.
Audience
This book is written for people who have some knowledge about MySQL. I tried to
include information useful for both beginners and advanced users. You need to know
SQL and have some idea of how the MySQL server works, at least from a user manual
or beginner’s guide. It’s better yet if you have real experience with the server or have
already encountered problems that were hard to solve.
ix

### Page 12

I don’t want to repeat what is in other information sources; rather, I want to fill those
gaps that I explained at the beginning of this Preface. So you’ll find guidance in this
book for fixing an application, but not the details of application and server behavior.
For details, consult the MySQL Reference Manual (http://dev.mysql.com/doc/refman/5
.5/en/index.html).
How to Solve a Problem
This book is shaped around the goal of pursuing problems and finding causes. I step
through what I would do to uncover the problem, without showing dozens of distract-
ing details or fancy methods.
It is very important to identify what the problem is.
For example, when saying that a MySQL installation is slow, you need
to identify where it is slow: is only part of the application affected, or
do all queries sent to the MySQL server run slowly? It’s also good to
know whether the same installation was “slow” in the past and whether
this problem is consistent or repeatable only periodically.
Another example is wrong behavior. You need to know what behaved
wrongly, what results you have, and what you expected.
I have been very disciplined in presenting troubleshooting methods. Most problems
can be solved in different ways, and the best solution depends on the application and
the user’s needs. If I described how to go off in every direction, this book would be 10
times bigger and you would miss the fix that works for you. My purpose is to put you
on the right path from the start so that you can deal quickly with each type of problem.
Details about fixing the issue can be found in other information sources, many of which
I cite and point you to in the course of our journey.
How This Book Is Organized
This book has seven chapters and an appendix.
Chapter 1, Basics, describes basic troubleshooting techniques that you’ll use in nearly
any situation. This chapter covers only single-threaded problems, i.e., problems that
are repeatable with a single connection in isolation. I start with this isolated and some-
what unrealistic setting because you will need these techniques to isolate a problem in
a multithreaded application.
x | Preface

### Page 13

Chapter 2, You Are Not Alone: Concurrency Issues, describes problems that come up
when applications run in multiple threads or interfere with transactions in other
applications.
Chapter 3, Effects of Server Options, consists of two parts. The first is a guide to
debugging and fixing a problem caused by a configuration option. The second is a
reference to important options and is meant to be consulted as needed instead of being
read straight through. The second part also contains recommendations on how to solve
problems caused by particular options and information about how to test whether you
have solved the problem. I tried to include techniques not described in other references,
and to consolidate in one place all the common problems with configuration options.
I also grouped them by the kind of problems, so you can easily search for the cause of
your symptom.
Chapter 4, MySQL’s Environment, is about hardware and other aspects of the envi-
ronment in which the server runs. This is a huge topic, but most of the necessary
information is specific to operating systems and often can be solved only by the system
administrator. So I list some points a MySQL database administrator (DBA) must look
into. After you read this short chapter, you will know when to blame your environment
and how to explain the problem to your system administrator.
Chapter 5, Troubleshooting Replication, is about problems that come up specifically in
replication scenarios. I actually discuss replication issues throughout this book, but
other chapters discuss the relationship between replication and other problems. This
chapter is for issues that are specific to replication.
Chapter 6, Troubleshooting Techniques and Tools, describes extra techniques and tools
that I skipped over or failed to discuss in detail during earlier guidelines to trouble-
shooting. The purpose of this chapter is to close all the gaps left in earlier chapters. You
can use it as a reference if you like. I show principles first, then mention available tools.
I can’t write about tools I don’t work with, so I explain the ones I personally use every
day, which consequently leads to a focus on tools written by the MySQL Team and
now belonging to Oracle. I do include third-party tools that help me deal with bugs
and support tickets every day.
Chapter 7, Best Practices, describes good habits and behaviors for safe and effective
troubleshooting. It does not describe all the best practices for designing MySQL
applications, which are covered in many other sources, but instead concentrates on
practices that help with problem hunting—or help prevent problems.
The Appendix, Information Resources, contains a list of information sources that I use
in my daily job and that can help in troubleshooting situations. Of course, some of
them influenced this book, and I refer to them where appropriate.
Preface | xi

### Page 14

Some Choices Made in This Book
In the past few years, many forks of MySQL were born. The most important are Percona
server and MariaDB. I skipped them completely in this book because I work mostly
with MySQL and simply cannot describe servers I don’t work with daily. However,
because they are forks, you can use most of the methods described here. Only if you
are dealing with a particular feature added in the fork will you need information specific
to that product.
To conserve space and avoid introducing a whole new domain of knowledge with a lot
of its own concerns, I left out MySQL Cluster problems. If you use MySQL Cluster and
run into an SQL or application issue, you can troubleshoot it in much the same way as
any other storage engine issue. Therefore, this book is applicable to such issues on
clusters. But issues that are specific to MySQL Cluster need separate MySQL Cluster
knowledge that I don’t describe here.
But I do devote a lot of space to MyISAM- and InnoDB-specific problems. This was
done because they are by far the most popular storage engines, and their installation
base is huge. Both also were and are default storage engines: MyISAM before
version 5.5 and InnoDB since version 5.5.
A few words about examples. They were all created either specially for this book or for
conferences where I have spoken about troubleshooting. Although some of the exam-
ples are based on real support cases and bug reports, all the code is new and cannot be
associated with any confidential data. In a few places, I describe customer “tickets.”
These are not real either. At the same time, the problems described here are real and
have been seen many times, just with different code, names, and circumstances.
I tried to keep all examples as simple, understandable, and universal as possible. There-
fore, I use the MySQL command-line client in most of the examples. You always have
this client in the MySQL installation.
This decision also explains why I don’t describe all complications specific to particular
kinds of installations; it is just impossible to cover them all in single book. Instead, I
tried to give starting points that you can extend.
I have decided to use the C API to illustrate the functions discussed in this book. The
choice wasn’t easy, because there are a lot of programming APIs for MySQL in various
languages. I couldn’t possibly cover them all, and didn’t want to guess which ones
would be popular. I realized that many of them look like the C API (many are even
wrappers around the C API), so I decided that would be the best choice. Even if you
are using an API with a very different syntax, such as ODBC, this section still can be
useful because you will know what to look for.
A few examples use PHP. I did so because I use PHP and therefore could show real
examples based on my own code. Real examples are always good to show because they
reflect real-life problems that readers are likely to encounter. In addition, the MySQL
xii | Preface

### Page 15

API in PHP is based on the C API and uses the very same names, so readers should be
able to compare it easily to C functions discussed in this book.1
I omitted JDBC and ODBC examples because these APIs are very specific. At the same
time, their debugging techniques are very similar, if not always the same. Mostly the
syntax is different. I decided that adding details about these two connectors might
confuse readers without offering any new information about troubleshooting.2
Conventions Used in This Book
The following typographical conventions are used in this book:
Italic
Indicates new terms, URLs, email addresses, filenames, and file extensions.
Constant width
Used for program listings, as well as within paragraphs to refer to program elements
such as variable or function names, databases, data types, environment variables,
statements, and keywords.
Constant width bold
Shows commands or other text that should be typed literally by the user.
Constant width italic
Shows text that should be replaced with user-supplied values or by values deter-
mined by context.
This icon signifies a tip, suggestion, or general note.
This icon indicates a warning or caution.
■This square indicates a lesson we just learned.
1. mysqlnd uses its own client protocol implementation, but still names functions in the same style as the
C API.
2. You can find details specific to Connector/J (JDBC) at http://dev.mysql.com/doc/refman/5.5/en/connector
-j-reference.html and to Connector/ODBC at http://dev.mysql.com/doc/refman/5.5/en/connector-odbc
-reference.html.
Preface | xiii

### Page 16

Using Code Examples
This book is here to help you get your job done. In general, you may use the code in
this book in your programs and documentation. You do not need to contact us for
permission unless you’re reproducing a significant portion of the code. For example,
writing a program that uses several chunks of code from this book does not require
permission. Selling or distributing a CD-ROM of examples from O’Reilly books does
require permission. Answering a question by citing this book and quoting example
code does not require permission. Incorporating a significant amount of example code
from this book into your product’s documentation does require permission.
We appreciate, but do not require, attribution. An attribution usually includes the title,
author, publisher, and ISBN. For example: “MySQL Troubleshooting by Sveta Smirnova
(O’Reilly). Copyright 2012 Sveta Smirnova, 978-1-449-31200-8.”
If you feel your use of code examples falls outside fair use or the permission given here,
feel free to contact us at permissions@oreilly.com.
Safari® Books Online
Safari Books Online is an on-demand digital library that lets you easily
search over 7,500 technology and creative reference books and videos to
find the answers you need quickly.
With a subscription, you can read any page and watch any video from our library online.
Read books on your cell phone and mobile devices. Access new titles before they are
available for print, get exclusive access to manuscripts in development, and post feed-
back for the authors. Copy and paste code samples, organize your favorites, download
chapters, bookmark key sections, create notes, print out pages, and benefit from tons
of other time-saving features.
O’Reilly Media has uploaded this book to the Safari Books Online service. To have full
digital access to this book and others on similar topics from O’Reilly and other pub-
lishers, sign up for free at http://my.safaribooksonline.com.
How to Contact Us
Please address comments and questions concerning this book to the publisher:
O’Reilly Media, Inc.
1005 Gravenstein Highway North
Sebastopol, CA 95472
800-998-9938 (in the United States or Canada)
707-829-0515 (international or local)
707-829-0104 (fax)
xiv | Preface

### Page 17

We have a web page for this book, where we list errata, examples, and any additional
information. You can access this page at:
http://www.oreilly.com/catalog/9781449312008
To comment or ask technical questions about this book, send email to:
bookquestions@oreilly.com
For more information about our books, courses, conferences, and news, see our website
at http://www.oreilly.com.
Find us on Facebook: http://facebook.com/oreilly
Follow us on Twitter: http://twitter.com/oreillymedia
Watch us on YouTube: http://www.youtube.com/oreillymedia
Acknowledgments
I want to say thank you to the people without whose help this book couldn’t happen.
For a start, this includes my editor, Andy Oram, who did a great job making my English
readable and who showed me gaps and places where I had not described information
in enough detail. He also gave me insight into how prepared my readers would be,
prompting me to add explanations for beginners and to remove trivial things known
by everyone.
I also want to thank the whole MySQL Support Team. These folks share their expertise
and support with every member of the team, and I learned a lot from them. I won’t put
names here, because I want to say “thank you” to all of the people with whom I’ve
worked since joining in 2006, even those who have left and moved to server develop-
ment or another company.
Thanks to Charles Bell, who helped me to start this book. He also did a review of the
book and suggested a lot of improvements. Charles works in the MySQL Replication
and Backup Team at Oracle and is the author of two books about MySQL. Therefore,
his suggestions, both for content and style, were very helpful.
I would also like to thank the people who reviewed the book:
• Shane Bester, my colleague from the MySQL Support Group, who reviewed the
part devoted to his Gypsy program and suggested how to improve the example.
• Alexander (Salle) Keremedarski, who reviewed the whole book and sent me a lot
of great suggestions. Salle has provided MySQL support since its very early days,
starting in the MySQL Support Team and now at SkySQL as Director of EMEA
Support. His knowledge of common user misunderstandings helped me to find
places where I explained things in too little detail, so that a troubleshooting situa-
tion could be read as a best practice when actually it is not.
Preface | xv

### Page 18

• Tonci Grgin, who reviewed the parts about MySQL Connectors and suggested
additions, explaining their behavior. Tonci used to work in the same group as me
and now works in the MySQL Connectors Team. He is the first person I would ask
about anything related to MySQL Connectors.
• Sinisa Milivojevic, who reviewed Chapters 3 and 4 and parts about the MyISAM
check and repairing tools. Sinisa is another reviewer who has worked in MySQL
Support since the very beginning. He was employee #2 in MySQL and still works
in the MySQL Support Team at Oracle. His huge experience is fantastic, and one
might even think he knows every little detail about the MySQL server. Sinisa gave
me insights on some of the topics I discuss and suggested short but very significant
improvements.
• Valeriy Kravchuk, who reviewed Chapters 2 and 4 and the section “InnoDB Mon-
itors” on page 192. He also works in the MySQL Support Team. Valeriy found
many deficiencies in the chapters he reviewed. His criticism forced me to improve
these chapters, although there is always room for development.
• Mark Callaghan, who runs database servers at Facebook, reviewed the whole book.
Mark suggested that I put more examples and further explanation in places that
were not clear. He also suggested examples for Chapter 4 and pointed me to places
where my suggestions can be wrong for certain installations, prompting me to
explain both situations: when the original suggestions fit and when they don’t.
Thanks to Mark, I added more details about these arguable topics.
• Alexey Kopytov also reviewed the whole book. He is the author of the SysBench
utility (which I describe in this book), worked in MySQL Development, and now
works at Percona. Alexey sent me improvements for the SysBench part.
• Dimitri (dim) Kravtchuk, Principal Benchmark Engineer at Oracle, reviewed the
whole book as well. He is also the author of the dim_STAT monitoring solution I
describe in this book, the db_STRESS database benchmarking kit, and a famous
blog where he posts articles about InnoDB performance and MySQL benchmarks.
He suggested several improvements to sections where I describe InnoDB, Perfor-
mance Schema, and hardware impacts.
Finally, thanks to my family:
• My mother, Yulia Ivanovna Ivanova, who showed me how fun engineering can be.
• My parents-in-law, Valentina Alekseevna Lasunova and Nikolay Nikolayevich
Lasunov, who always helped us when we needed it.
• And last but not least, my husband, Sergey Lasunov, who supported me in all my
initiatives.
xvi | Preface

### Page 19

CHAPTER 1
Basics
When troubleshooting, you can generally save time by starting with the simplest pos-
sible causes and working your way to more complicated ones. I work dozens of trouble
tickets at MySQL Support every month. For most of them, we start from trivial requests
for information, and the final resolution may—as we’ll see in some examples—be trivial
as well, but sometimes we have quite an adventure in between. So it always pays to
start with the basics.
The typical symptoms of a basic problem are running a query and getting unexpected
results. The problem could manifest itself as results that are clearly wrong, getting no
results back when you know there are matching rows, or odd behavior in the applica-
tion. In short, this section depends on you having a good idea of what your application
should be doing and what the query results should look like. Cases in which the source
of wrong behavior is not so clear will be discussed later in this book.
We will always return to these basics, even with the trickiest errors or in situations
when you would not know what caused the wrong behavior in your application. This
process, which we’ll discuss in depth in “Localizing the Problem (Minimizing the Test
Case)” on page 205, can also be called creating a minimal test case.
Incorrect Syntax
This sounds absolutely trivial, but still can be tricky to find. I recommend you approach
the possibility of incorrect SQL syntax very rigorously, like any other possible problem.
An error such as the following is easy to see:
SELECT * FRO t1 WHERE f1 IN (1,2,1);
In this case, it is clear that the user just forgot to type an “m”, and the error message
clearly reports this (I have broken the output lines to fit the page):
mysql> SELECT * FRO t1 WHERE f1 IN (1,2,1);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that
corresponds to your MySQL server version for the right syntax to use near 'FRO
t1 WHERE f1 IN (1,2,1)' at line 1
1

### Page 20

Unfortunately, not all syntax errors are so trivial. I once worked on a trouble ticket
concerning a query like this:
SELECT id FROM t1 WHERE accessible=1;
The problem was a migration issue; the query worked fine in version 5.0 but stopped
working in version 5.1. The problem was that, in version 5.1, “accessible” is a reserved
word. We added quotes (these can be backticks or double quotes, depending on your
SQL mode), and the query started working again:
SELECT `id` FROM `t1` WHERE `accessible`=1;
The actual query looked a lot more complicated, with a large JOIN and a complex
WHERE condition. So the simple error was hard to pick out among all the distractions.
Our first task was to reduce the complex query to the simple one-line SELECT as just
shown, which is an example of a minimal test case. Once we realized that the one-liner
had the same bug as the big, original query, we quickly realized that the programmer
had simply stumbled over a reserved word.
■The first lesson is to check your query for syntax errors as the first troubleshooting
step.
But what do you do if you don’t know the query? For example, suppose the query was
built by an application. Even more fun is in store when it’s a third-party library that
dynamically builds queries.
Let’s consider this PHP code:
$query = 'SELECT * FROM t4 WHERE f1 IN(';
for ($i = 1; $i < 101; $i ++)
$query .= "'row$i,";
$query = rtrim($query, ',');
$query .= ')';
$result = mysql_query($query);
Looking at the script, it is not easy to see where the error is. Fortunately, we can alter
the code to print the query using an output function. In the case of PHP, this can be
the echo operator. So we modify the code as follows:
…
echo $query;
//$result = mysql_query($query);
Once the program shows us the actual query it’s trying to submit, the problem jumps
right out:
$ php ex1.php
SELECT * FROM t4 WHERE f1 IN('row1,'row2,'row3,'row4,'row5,'row6,'row7,'row8,
'row9,'row10,'row11, 'row12,'row13,'row14,'row15,'row16,'row17,'row18,'row19,'row20)
If you still can’t find the error, try running this query in the MySQL command-line
client:
2 | Chapter 1: Basics

### Page 21

mysql> SELECT * FROM t4 WHERE f1 IN('row1,'row2,'row3,'row4,'row5,'row6,'row7,'row8,
'row9,'row10,'row11,'row12,'row13,'row14,'row15,'row16,'row17,'row18,'row19,'row20);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that
corresponds to your MySQL server version for the right syntax to use near 'row2,
'row3,'row4,'row5,'row6,'row7,'row8,'row9,'row10,'row11, 'row12,'row13,'row' at
line 1
The problem is that the closing apostrophe is missing from each row. Going back to
the PHP code, I have to change:
$query .= "'row$i,";
to the following:
$query .= "'row$i',";
■An important debugging technique, therefore, consists of this: always try to view
the query exactly as the MySQL server receives it. Don’t debug only application
code; get the query!
Unfortunately, you can’t always use output functions. One possible reason, which I
mentioned before, is that you’re using a third-party library written in a compiled
language to generate the SQL. Your application might also be using high-level abstrac-
tions, such as libraries that offer a CRUD (create, read, update, delete) interface. Or
you might be in a production environment where you don’t want users to be able to
see the query while you are testing particular queries with specific parameters. In such
cases, check the MySQL general query log. Let’s see how it works using a new example.
This is the PHP application where the problem exists:
private function create_query($columns, $table)
{
    $query = "insert into $table set ";
    foreach ($columns as $column) {
        $query .= $column['column_name'] . '=';
        $query .= $this->generate_for($column);
        $query .= ', ';
    }
    return rtrim($query, ',') . ';';
}
private function generate_for($column)
{
    switch ($column['data_type']) {
    case 'int':
        return rand();
    case 'varchar':
    case 'text':
      return "'" . str_pad(md5(rand()), rand(1,$column['character_maximum_length']),
      md5(rand()), STR_PAD_BOTH) . "'";
    default:
        return "''";
    }
}
Incorrect Syntax | 3

### Page 22

This code updates a table defined in Example 1-1.
Example 1-1. Sample table of common troubleshooting situations
CREATE TABLE items(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    short_description VARCHAR(255),
    description TEXT,
    example TEXT,
    explanation TEXT,
    additional TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
Now is time to start using the general query log. This log contains every single query
the MySQL server receives. Many production applications don’t want to use it on a
day-to-day basis, because it grows extremely fast during a high load, and writing to it
can take up MySQL server resources that are needed for more important purposes.
Starting with version 5.1, you can turn the general query log on temporarily to record
just the query you need:
mysql> SET GLOBAL general_log='on';
Query OK, 0 rows affected (0.00 sec)
You can also log into a table, which lets you easily sort logfile entries because you can
query a log table like any other MySQL table:
mysql> SET GLOBAL log_output='table';
Query OK, 0 rows affected (0.00 sec)
Now let’s run the application. After an iteration that executes the problem code, query
the table containing the general log to find the problem query:
mysql> SELECT * FROM mysql.general_log\G
*************************** 1. row ***************************
  event_time: 2011-07-13 02:54:37
   user_host: root[root] @ localhost []
   thread_id: 27515
   server_id: 60
command_type: Connect
    argument: root@localhost on collaborate2011
*************************** 2. row ***************************
  event_time: 2011-07-13 02:54:37
   user_host: root[root] @ localhost []
   thread_id: 27515
   server_id: 60
command_type: Query
    argument: INSERT INTO items SET id=1908908263,
short_description='8786db20e5ada6cece1306d44436104c',
description='fc84e1dc075bca3fce13a95c41409764',
example='e4e385c3952c1b5d880078277c711c41',
explanation='ba0afe3fb0e7f5df1f2ed3f2303072fb',
additional='2208b81f320e0d704c11f167b597be85',
*************************** 3. row ***************************
  event_time: 2011-07-13 02:54:37
   user_host: root[root] @ localhost []
4 | Chapter 1: Basics

### Page 23

thread_id: 27515
   server_id: 60
command_type: Quit
    argument:
We are interested in the second row and query:
INSERT INTO items SET id=1908908263,
short_description='8786db20e5ada6cece1306d44436104c',
description='fc84e1dc075bca3fce13a95c41409764',
example='e4e385c3952c1b5d880078277c711c41',
explanation='ba0afe3fb0e7f5df1f2ed3f2303072fb',
additional='2208b81f320e0d704c11f167b597be85',
The error again is trivial: a superfluous comma at the end of the query. The problem
was generated in this part of the PHP code:
        $query .= ', ';
    }
    return rtrim($query, ',') . ';';
The rtrim function would work if the string actually ended with a comma because it
could remove the trailing comma. But the line actually ends with a space character. So
rtrim does not remove anything.
Now that we have the query that caused the error in our application, we can turn off
the general query log:
mysql> SET GLOBAL general_log='off';
Query OK, 0 rows affected (0.08 sec)
In this section, we learned a few important things:
• Incorrect syntax can be the source of real-life problems.
• You should test exactly the same query that the MySQL server gets.
• Programming language output functions and the general query log can help you
quickly find the query that the application sends to the MySQL server.
Wrong Results from a SELECT
This is another frequent problem reported by users of an application who don’t see the
updates they made, see them in the wrong order, or see something they don’t expect.
There are two main reasons for getting wrong results: something is wrong with your
SELECT query, or the data in database differs from what you expect. I’ll start with the
first case.
When I went over examples for this section, I had to either show some real-life examples
or write my own toy cases. The real-life examples can be overwhelmingly large, but the
toy cases wouldn’t be much help to you, because nobody writes such code. So I’ve
chosen to use some typical real-life examples, but simplified them dramatically.
Wrong Results from a SELECT | 5

### Page 24

The first example involves a common user mistake when using huge joins. We will use
Example 1-1, described in the previous section. This table contains my collection of
MySQL features that cause common usage mistakes I deal with in MySQL Support.
Each mistake has a row in the items table. I have another table of links to resources
for information. Because there’s a many-to-many relationship between items and links,
I also maintain an items_links table to tie them together. Here are the definitions of
the items and items_links table (we don’t need links in this example):
mysql> DESC items;
+-------------------+--------------+------+-----+---------+----------------+
| Field             | Type         | Null | Key | Default | Extra          |
+-------------------+--------------+------+-----+---------+----------------+
| id                | int(11)      | NO   | PRI | NULL    | auto_increment |
| short_description | varchar(255) | YES  |     | NULL    |                |
| description       | text         | YES  |     | NULL    |                |
| example           | text         | YES  |     | NULL    |                |
| explanation       | text         | YES  |     | NULL    |                |
| additional        | text         | YES  |     | NULL    |                |
+-------------------+--------------+------+-----+---------+----------------+
6 rows in set (0.30 sec)
mysql> DESC items_links;
+--------+---------+------+-----+---------+-------+
| Field  | Type    | Null | Key | Default | Extra |
+--------+---------+------+-----+---------+-------+
| iid    | int(11) | YES  | MUL | NULL    |       |
| linkid | int(11) | YES  | MUL | NULL    |       |
+--------+---------+------+-----+---------+-------+
2 rows in set (0.11 sec)
The first query I wrote worked fine and returned a reasonable result:
mysql> SELECT count(*) FROM items WHERE id IN (SELECT id FROM items_links);
+----------+
| count(*) |
+----------+
|       10 |
+----------+
1 row in set (0.12 sec)
...until I compared the number returned with the total number of links:
mysql> SELECT count(*) FROM items_links;
+----------+
| count(*) |
+----------+
|        6 |
+----------+
1 row in set (0.09 sec)
How could it be possible to have more links than associations?
Let’s examine the query, which I made specially for this book, once more. It is simple
and contains only two parts, a subquery:
SELECT id FROM items_links
6 | Chapter 1: Basics

### Page 25

and an outer query:
SELECT count(*) FROM items WHERE id IN ...
The subquery can be a good place to start troubleshooting because one should be able
to execute it independently. Therefore, we can expect a compete result set:
mysql> SELECT id FROM items_links;
ERROR 1054 (42S22): Unknown column 'id' in 'field list'
Surprise! We have a typo, and actually there is no field named id in the items_links
table; it says iid (for “items ID”) instead. If we rewrite our query so that it uses the
correct identifiers, it will work properly:
mysql> SELECT count(*) FROM items WHERE id IN (SELECT iid FROM items_links);
+----------+
| count(*) |
+----------+
|        4 |
+----------+
1 row in set (0.08 sec)
■We just learned a new debugging technique. If a SELECT query does not work as
expected, split it into smaller chunks, and then analyze each part until you find the
cause of the incorrect behavior.
If you specify the full column name by using the format
table_name.column_name, you can prevent the problems described here
in the first place because you will get an error immediately:
mysql> SELECT count(*) FROM items WHERE items.id IN 
       (SELECT items_links.id FROM items_links); 
ERROR 1054 (42S22): Unknown column 'items_links.id' in 'field list'
A good tool for testing is the simple MySQL command-line client that comes with a
MySQL installation. We will discuss the importance of this tool in Chapter 6.
But why didn’t MySQL return the same error for the first query? We have a field named
id in the items table, so MySQL thought we wanted to run a dependent subquery that
actually selects items.id from items_links. A “dependent subquery” is one that refers
to fields from the outer query.
We can also use EXPLAIN EXTENDED followed by SHOW WARNINGS to find the mistake. If we
run these commands on the original query, we get:
mysql> EXPLAIN EXTENDED SELECT count(*) FROM items WHERE id IN 
(SELECT id FROM items_links)\G
2 rows in set, 2 warnings (0.12 sec)
*************************** 1. row ***************************
           id: 1
  select_type: PRIMARY
        table: items
         type: index
Wrong Results from a SELECT | 7

### Page 26

possible_keys: NULL
          key: PRIMARY
      key_len: 4
          ref: NULL
         rows: 10
     filtered: 100.00
        Extra: Using where; Using index
*************************** 2. row ***************************
           id: 2
  select_type: DEPENDENT SUBQUERY
        table: items_links
         type: index
possible_keys: NULL
          key: iid_2
      key_len: 5
          ref: NULL
         rows: 6
     filtered: 100.00
        Extra: Using where; Using index
2 rows in set, 2 warnings (0.54 sec)
mysql> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1276
Message: Field or reference 'collaborate2011.items.id' of SELECT #2 was resolved
in SELECT #1
*************************** 2. row ***************************
  Level: Note
   Code: 1003
Message: select count(0) AS `count(*)` from `collaborate2011`.`items` where
<in_optimizer7gt;(`collaborate2011`.`items`.`id`,<exists>(select 1 from
`collaborate2011`.`items_links` where
(<cache>(`collaborate2011`.`items`.`id`) =
`collaborate2011`.`items`.`id`)))
2 rows in set (0.00 sec)
Row 2 of the EXPLAIN EXTENDED output shows that the subquery is actually dependent:
select_type is DEPENDENT SUBQUERY.
Before moving on from this example, I want to show one more technique that will help
you avoid getting lost when your query contains lots of table references. It is easy to
get lost if you join 10 or more tables in a single query, even when you know how they
should be joined.
The interesting part of the previous example was the output of SHOW WARNINGS. The
MySQL server does not always execute a query as it was typed, but invokes the opti-
mizer to create a better execution plan so that the user usually gets the results faster.
Following EXPLAIN EXTENDED, the SHOW WARNINGS command shows the optimized query.
In our example, the SHOW WARNINGS output contains two notes. The first is:
Field or reference 'collaborate2011.items.id' of SELECT #2 was resolved in SELECT #1
8 | Chapter 1: Basics

### Page 27

This note clearly shows that the server resolved the value of id in the subquery from
the items table rather than from items_links.
The second note contains the optimized query:
select count(0) AS `count(*)` from `collaborate2011`.`items` where <in_optimizer>
(`collaborate2011`.`items`.`id`,<exists>
(select 1 from `collaborate2011`.`items_links` where
(<cache>(`collaborate2011`.`items`.`id`) = `collaborate2011`.`items`.`id`)))
This output also shows that the server takes the value of id from the items table.
Now let’s compare the previous listing with the result of EXPLAIN EXTENDED on the
correct query:
mysql> EXPLAIN EXTENDED SELECt count(*) FROM items WHERE id IN
(SELECT iid FROM items_links)\G
*************************** 1. row ***************************
           id: 1
  select_type: PRIMARY
        table: items
         type: index
possible_keys: NULL
          key: PRIMARY
      key_len: 4
          ref: NULL
         rows: 10
     filtered: 100.00
        Extra: Using where; Using index
*************************** 2. row ***************************
           id: 2
  select_type: DEPENDENT SUBQUERY
        table: items_links
         type: index_subquery
possible_keys: iid,iid_2
          key: iid
      key_len: 5
          ref: func
         rows: 1
     filtered: 100.00
        Extra: Using index; Using where
2 rows in set, 1 warning (0.03 sec)
mysql> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: select count(0) AS `count(*)` from `collaborate2011`.`items` where
<in_optimizer>(`collaborate2011`.`items`.`id`,<exists>
(<index_lookup>(<cache>(`collaborate2011`.`items`.`id`) in
items_links on iid where (<cache>(`collaborate2011`.`items`.`id`) =
`collaborate2011`.`items_links`.`iid`))))
1 row in set (0.00 sec)
The optimized query this time looks completely different, and really compares
items.id with items_links.iid as we intended.
Wrong Results from a SELECT | 9

### Page 28

■We just learned another lesson: use EXPLAIN EXTENDED followed by SHOW WARNINGS
to find how a query was optimized (and executed).
The value of select_type in the correct query is still DEPENDENT SUBQUERY. How can that
be if we resolve the field name from the items_links table? The explanation starts with
the part of the SHOW WARNINGS output that reads as follows:
where (<cache>(`collaborate2011`.`items`.`id`) = 
`collaborate2011`.`items_links`.`iid`)
The subquery is still dependent because the id in clause of the outer query requires
the subquery to check its rows against the value of iid in the inner query. This issue
came up in the discussion of report #12106 in the MySQL Community Bugs Database.
■I added a link to the bug report because it provides another important lesson: if
you doubt the behavior of your query, use good sources to find information. The
community bug database is one such source.
There can be many different reasons why a SELECT query behaves incorrectly, but the
general method of investigation is always the same:
• Split the query into small chunks, and then execute them one by one until you see
the cause of the problem.
• Use EXPLAIN EXTENDED followed by SHOW WARNINGS to get the query execution plan
and information on how it was actually executed.
• If you don’t understand the MySQL server behavior, use the Internet and good
sources for information. The Appendix includes a list of useful resources.
When the Problem May Have Been a Previous Update
If a SELECT returns a result set you don’t expect, this does not always mean something
is wrong with the query itself. Perhaps you didn’t insert, update, or delete data that you
thought you had.
Before you investigate this possibility, you should faithfully carry out the investigation
in the previous section, where we discussed a badly written SELECT statement. Here I
examine the possibility that you have a good SELECT that is returning the values you
asked for, and that the problem is your data itself. To make sure the problem is in the
data and not the SELECT, try to reduce it to a simple quer