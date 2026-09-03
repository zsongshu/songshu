---
title: "-MySQL.High.Availability-2nd-2014.4--.Charles.Bell.文字版"
source: "-MySQL.High.Availability-2nd-2014.4--.Charles.Bell.文字版.pdf"
type: book
tags: ["book", "mysql"]
created: 2026-07-03
---

# -MySQL.High.Availability-2nd-2014.4--.Charles.Bell.文字版

![[MySQL.High.Availability-2nd-2014.4--.Charles.Bell.文字版-729f58c2.pdf]]

## 内容

### Page 3

Charles Bell, Mats Kindahl, and Lars Thalmann
SECOND EDITION
MySQL High Availability

### Page 4

MySQL High Availability, Second Edition
by Charles Bell, Mats Kindahl, and Lars Thalmann
Copyright © 2014 Charles Bell, Mats Kindahl, Lars Thalmann. All rights reserved.
Printed in the United States of America.
Published by O’Reilly Media, Inc., 1005 Gravenstein Highway North, Sebastopol, CA 95472.
O’Reilly books may be purchased for educational, business, or sales promotional use. Online editions are
also available for most titles (http://my.safaribooksonline.com). For more information, contact our corporate/
institutional sales department: 800-998-9938 or corporate@oreilly.com.
Editor: Andy Oram
Production Editor: Nicole Shelby
Copyeditor: Jasmine Kwityn
Proofreader: Linley Dolby
Indexer: Lucie Haskins
Cover Designer: Karen Montgomery
Interior Designer: David Futato
Illustrator: Rebecca Demarest
June 2010:
First Edition
April 2014:
Second Edition
Revision History for the Second Edition:
2014-04-09: First release
See http://oreilly.com/catalog/errata.csp?isbn=9781449339586 for release details.
Nutshell Handbook, the Nutshell Handbook logo, and the O’Reilly logo are registered trademarks of O’Reilly
Media, Inc. MySQL High Availability, the image of an American robin, and related trade dress are trademarks
of O’Reilly Media, Inc.
Many of the designations used by manufacturers and sellers to distinguish their products are claimed as
trademarks. Where those designations appear in this book, and O’Reilly Media, Inc. was aware of a trademark
claim, the designations have been printed in caps or initial caps.
While every precaution has been taken in the preparation of this book, the publisher and authors assume
no responsibility for errors or omissions, or for damages resulting from the use of the information contained
herein.
ISBN: 978-1-449-33958-6
[LSI]

### Page 5

Table of Contents
Foreword for the Second Edition. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  xv
Foreword for the First Edition. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  xix
Preface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  xxi
Part I. 
High Availability and Scalability
1. Introduction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  3
What’s This Replication Stuff, Anyway?                                                                         5
So, Backups Are Not Needed Then?                                                                                7
What’s With All the Monitoring?                                                                                    7
Is There Anything Else I Can Read?                                                                                8
Conclusion                                                                                                                          9
2. MySQL Replicant Library. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  11
Basic Classes and Functions                                                                                           15
Supporting Different Operating Systems                                                                     16
Servers                                                                                                                               17
Server Roles                                                                                                                      19
Conclusion                                                                                                                        21
3. MySQL Replication Fundamentals. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  23
Basic Steps in Replication                                                                                               24
Configuring the Master                                                                                               25
Configuring the Slave                                                                                                  27
Connecting the Master and Slave                                                                              28
A Brief Introduction to the Binary Log                                                                        29
What’s Recorded in the Binary Log                                                                           30
Watching Replication in Action                                                                                 30
The Binary Log’s Structure and Content                                                                   33
iii

### Page 6

Adding Slaves                                                                                                                   35
Cloning the Master                                                                                                      37
Cloning a Slave                                                                                                             39
Scripting the Clone Operation                                                                                   41
Performing Common Tasks with Replication                                                             42
Reporting                                                                                                                       43
Conclusion                                                                                                                        49
4. The Binary Log. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  51
Structure of the Binary Log                                                                                            52
Binlog Event Structure                                                                                                 54
Event Checksums                                                                                                         56
Logging Statements                                                                                                          58
Logging Data Manipulation Language Statements                                                 58
Logging Data Definition Language Statements                                                       59
Logging Queries                                                                                                           59
LOAD DATA INFILE Statements                                                                              65
Binary Log Filters                                                                                                         67
Triggers, Events, and Stored Routines                                                                       70
Stored Procedures                                                                                                        75
Stored Functions                                                                                                          78
Events                                                                                                                             81
Special Constructions                                                                                                  82
Nontransactional Changes and Error Handling                                                      83
Logging Transactions                                                                                                      86
Transaction Cache                                                                                                        87
Distributed Transaction Processing Using XA                                                        91
Binary Log Group Commit                                                                                        94
Row-Based Replication                                                                                                   97
Enabling Row-based Replication                                                                               98
Using Mixed Mode                                                                                                       99
Binary Log Management                                                                                              100
The Binary Log and Crash Safety                                                                            100
Binlog File Rotation                                                                                                   101
Incidents                                                                                                                      103
Purging the Binlog File                                                                                              104
The mysqlbinlog Utility                                                                                                105
Basic Usage                                                                                                                  106
Interpreting Events                                                                                                    113
Binary Log Options and Variables                                                                              118
Options for Row-Based Replication                                                                        120
iv 
| 
Table of Contents

### Page 7

Conclusion                                                                                                                      121
5. Replication for High Availability. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  123
Redundancy                                                                                                                    124
Planning                                                                                                                          126
Slave Failures                                                                                                               127
Master Failures                                                                                                           127
Relay Failures                                                                                                              127
Disaster Recovery                                                                                                       127
Procedures                                                                                                                      128
Hot Standby                                                                                                                130
Dual Masters                                                                                                               135
Slave Promotion                                                                                                         144
Circular Replication                                                                                                   149
Conclusion                                                                                                                      151
6. MySQL Replication for Scale-Out. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  153
Scaling Out Reads, Not Writes                                                                                     155
The Value of Asynchronous Replication                                                                    156
Managing the Replication Topology                                                                           158
Application-Level Load Balancing                                                                           162
Hierarchical Replication                                                                                               170
Setting Up a Relay Server                                                                                          171
Adding a Relay in Python                                                                                         172
Specialized Slaves                                                                                                           173
Filtering Replication Events                                                                                      174
Using Filtering to Partition Events to Slaves                                                          176
Managing Consistency of Data                                                                                    177
Consistency in a Nonhierarchical Deployment                                                     178
Consistency in a Hierarchical Deployment                                                            180
Conclusion                                                                                                                      187
7. Data Sharding. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  189
What Is Sharding?                                                                                                          190
Why Should You Shard?                                                                                            191
Limitations of Sharding                                                                                             192
Elements of a Sharding Solution                                                                                 194
High-Level Sharding Architecture                                                                          196
Partitioning the Data                                                                                                     197
Shard Allocation                                                                                                         202
Mapping the Sharding Key                                                                                           206
Sharding Scheme                                                                                                        206
Table of Contents 
| 
v

### Page 8

Shard Mapping Functions                                                                                         210
Processing Queries and Dispatching Transactions                                                   215
Handling Transactions                                                                                              216
Dispatching Queries                                                                                                  218
Shard Management                                                                                                        220
Moving a Shard to a Different Node                                                                       220
Splitting Shards                                                                                                           225
Conclusion                                                                                                                      225
8. Replication Deep Dive. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  227
Replication Architecture Basics                                                                                   228
The Structure of the Relay Log                                                                                 229
The Replication Threads                                                                                           233
Starting and Stopping the Slave Threads                                                                234
Running Replication over the Internet                                                                       235
Setting Up Secure Replication Using Built-in Support                                         237
Setting Up Secure Replication Using Stunnel                                                        238
Finer-Grained Control Over Replication                                                                   239
Information About Replication Status                                                                    239
Options for Handling Broken Connections                                                              248
How the Slave Processes Events                                                                                   249
Housekeeping in the I/O Thread                                                                             249
SQL Thread Processing                                                                                             250
Semisynchronous Replication                                                                                      257
Configuring Semisynchronous Replication                                                           258
Monitoring Semisynchronous Replication                                                            259
Global Transaction Identifiers                                                                                     260
Setting Up Replication Using GTIDs                                                                      261
Failover Using GTIDs                                                                                                263
Slave Promotion Using GTIDs                                                                                 264
Replication of GTIDs                                                                                                 266
Slave Safety and Recovery                                                                                             268
Syncing, Transactions, and Problems with Database Crashes                             268
Transactional Replication                                                                                         270
Rules for Protecting Nontransactional Statements                                               274
Multisource Replication                                                                                                275
Details of Row-Based Replication                                                                               278
Table_map Events                                                                                                      280
The Structure of Row Events                                                                                    282
Execution of Row Event                                                                                            283
Events and Triggers                                                                                                    284
Filtering in Row-Based Replication                                                                         286
vi 
| 
Table of Contents

### Page 9

Partial Row Replication                                                                                             288
Conclusion                                                                                                                      289
9. MySQL Cluster. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  291
What Is MySQL Cluster?                                                                                              292
Terminology and Components                                                                                292
How Does MySQL Cluster Differ from MySQL?                                                  293
Typical Configuration                                                                                                293
Features of MySQL Cluster                                                                                       294
Local and Global Redundancy                                                                                 296
Log Handling                                                                                                              297
Redundancy and Distributed Data                                                                          297
Architecture of MySQL Cluster                                                                                   298
How Data Is Stored                                                                                                    300
Partitioning                                                                                                                 303
Transaction Management                                                                                         304
Online Operations                                                                                                     304
Example Configuration                                                                                                 306
Getting Started                                                                                                            306
Starting a MySQL Cluster                                                                                         308
Testing the Cluster                                                                                                     313
Shutting Down the Cluster                                                                                       314
Achieving High Availability                                                                                         314
System Recovery                                                                                                         317
Node Recovery                                                                                                            318
Replication                                                                                                                  319
Achieving High Performance                                                                                       324
Considerations for High Performance                                                                    325
High Performance Best Practices                                                                             326
Conclusion                                                                                                                      328
Part II. 
Monitoring and Managing
10. Getting Started with Monitoring. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  333
Ways of Monitoring                                                                                                       334
Benefits of Monitoring                                                                                                  335
System Components to Monitor                                                                                 335
Processor                                                                                                                     336
Memory                                                                                                                       337
Disk                                                                                                                              338
Network Subsystem                                                                                                   339
Table of Contents 
| 
vii

### Page 10

Monitoring Solutions                                                                                                    340
Linux and Unix Monitoring                                                                                         341
Process Activity                                                                                                          342
Memory Usage                                                                                                            347
Disk Usage                                                                                                                   350
Network Activity                                                                                                        353
General System Statistics                                                                                           355
Automated Monitoring with cron                                                                           356
Mac OS X Monitoring                                                                                                   356
System Profiler                                                                                                            357
Console                                                                                                                        359
Activity Monitor                                                                                                         361
Microsoft Windows Monitoring                                                                                 365
The Windows Experience                                                                                         366
The System Health Report                                                                                        367
The Event Viewer                                                                                                       369
The Reliability Monitor                                                                                             372
The Task Manager                                                                                                      374
The Performance Monitor                                                                                        375
Monitoring as Preventive Maintenance                                                                     377
Conclusion                                                                                                                      377
11. Monitoring MySQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  379
What Is Performance?                                                                                                   380
MySQL Server Monitoring                                                                                           381
How MySQL Communicates Performance                                                            381
Performance Monitoring                                                                                          382
SQL Commands                                                                                                         383
The mysqladmin Utility                                                                                            389
MySQL Workbench                                                                                                   391
Third-Party Tools                                                                                                       402
The MySQL Benchmark Suite                                                                                  405
Server Logs                                                                                                                      407
Performance Schema                                                                                                     409
Concepts                                                                                                                      410
Getting Started                                                                                                            412
Using Performance Schema to Diagnose Performance Problems                      420
MySQL Monitoring Taxonomy                                                                                   421
Database Performance                                                                                                  423
Measuring Database Performance                                                                           423
Best Practices for Database Optimization                                                              435
Best Practices for Improving Performance                                                                444
viii 
| 
Table of Contents

### Page 11

Everything Is Slow                                                                                                      444
Slow Queries                                                                                                               444
Slow Applications                                                                                                       445
Slow Replication                                                                                                         445
Conclusion                                                                                                                      446
12. Storage Engine Monitoring. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  447
InnoDB                                                                                                                            448
Using the SHOW ENGINE Command                                                                  450
Using InnoDB Monitors                                                                                           453
Monitoring Logfiles                                                                                                   457
Monitoring the Buffer Pool                                                                                      458
Monitoring Tablespaces                                                                                            460
Using INFORMATION_SCHEMA Tables                                                             461
Using PERFORMANCE_SCHEMA Tables                                                           462
Other Parameters to Consider                                                                                 463
Troubleshooting Tips for InnoDB                                                                           464
MyISAM                                                                                                                          467
Optimizing Disk Storage                                                                                           467
Repairing Your Tables                                                                                                468
Using the MyISAM Utilities                                                                                     468
Storing a Table in Index Order                                                                                 470
Compressing Tables                                                                                                   471
Defragmenting Tables                                                                                                471
Monitoring the Key Cache                                                                                        471
Preloading Key Caches                                                                                              472
Using Multiple Key Caches                                                                                       473
Other Parameters to Consider                                                                                 474
Conclusion                                                                                                                      475
13. Replication Monitoring. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  477
Getting Started                                                                                                               477
Server Setup                                                                                                                    478
Inclusive and Exclusive Replication                                                                            478
Replication Threads                                                                                                       481
Monitoring the Master                                                                                                  483
Monitoring Commands for the Master                                                                  483
Master Status Variables                                                                                              487
Monitoring Slaves                                                                                                          487
Monitoring Commands for the Slave                                                                      487
Slave Status Variables                                                                                                 492
Replication Monitoring with MySQL Workbench                                                   493
Table of Contents 
| 
ix

### Page 12

Other Items to Consider                                                                                               495
Networking                                                                                                                 495
Monitor and Manage Slave Lag                                                                                496
Causes and Cures for Slave Lag                                                                                497
Working with GTIDs                                                                                                 498
Conclusion                                                                                                                      499
14. Replication Troubleshooting. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  501
What Can Go Wrong                                                                                                    502
Problems on the Master                                                                                                503
Master Crashed and Memory Tables Are in Use                                                   503
Master Crashed and Binary Log Events Are Missing                                           503
Query Runs Fine on the Master but Not on the Slave                                          505
Table Corruption After a Crash                                                                               505
Binary Log Is Corrupt on the Master                                                                      506
Killing Long-Running Queries for Nontransactional Tables                               507
Unsafe Statements                                                                                                      507
Problems on the Slave                                                                                                   509
Slave Server Crashed and Replication Won’t Start                                                510
Slave Connection Times Out and Reconnects Frequently                                   510
Query Results Are Different on the Slave than on the Master                            511
Slave Issues Errors when Attempting to Restart with SSL                                   512
Memory Table Data Goes Missing                                                                          513
Temporary Tables Are Missing After a Slave Crash                                              513
Slave Is Slow and Is Not Synced with the Master                                                  513
Data Loss After a Slave Crash                                                                                   514
Table Corruption After a Crash                                                                               514
Relay Log Is Corrupt on the Slave                                                                            515
Multiple Errors During Slave Restart                                                                      515
Consequences of a Failed Transaction on the Slave                                              515
I/O Thread Problems                                                                                                 515
SQL Thread Problems: Inconsistencies                                                                  516
Different Errors on the Slave                                                                                    517
Advanced Replication Problems                                                                                  517
A Change Is Not Replicated Among the Topology                                               517
Circular Replication Issues                                                                                       518
Multimaster Issues                                                                                                     518
The HA_ERR_KEY_NOT_FOUND Error                                                            519
GTID Problems                                                                                                          519
Tools for Troubleshooting Replication                                                                       520
Best Practices                                                                                                                  521
Know Your Topology                                                                                                 521
x 
| 
Table of Contents

### Page 13

Check the Status of All of Your Servers                                                                  523
Check Your Logs                                                                                                         523
Check Your Configuration                                                                                        524
Conduct Orderly Shutdowns                                                                                    525
Conduct Orderly Restarts After a Failure                                                               525
Manually Execute Failed Queries                                                                             526
Don’t Mix Transactional and Nontransactional Tables                                        526
Common Procedures                                                                                                 526
Reporting Replication Bugs                                                                                          528
Conclusion                                                                                                                      529
15. Protecting Your Investment. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  531
What Is Information Assurance?                                                                                 532
The Three Practices of Information Assurance                                                     532
Why Is Information Assurance Important?                                                           533
Information Integrity, Disaster Recovery, and the Role of Backups                      533
High Availability Versus Disaster Recovery                                                           534
Disaster Recovery                                                                                                       535
The Importance of Data Recovery                                                                           541
Backup and Restore                                                                                                   542
Backup Tools and OS-Level Solutions                                                                        547
MySQL Enterprise Backup                                                                                       548
MySQL Utilities Database Export and Import                                                       559
The mysqldump Utility                                                                                             560
Physical File Copy                                                                                                      562
Logical Volume Manager Snapshots                                                                       564
XtraBackup                                                                                                                  569
Comparison of Backup Methods                                                                             569
Backup and MySQL Replication                                                                                  570
Backup and Recovery with Replication                                                                  571
PITR                                                                                                                             571
Automating Backups                                                                                                     579
Conclusion                                                                                                                      581
16. MySQL Enterprise Monitor. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  583
Getting Started with MySQL Enterprise Monitor                                                     584
Commercial Offerings                                                                                               585
Anatomy of MySQL Enterprise Monitor                                                                585
Installation Overview                                                                                                586
MySQL Enterprise Monitor Components                                                                  590
Dashboard                                                                                                                   591
Monitoring Agent                                                                                                      594
Table of Contents 
| 
xi

### Page 14

Advisors                                                                                                                       594
Query Analyzer                                                                                                          595
MySQL Production Support                                                                                     597
Using MySQL Enterprise Monitor                                                                              597
Monitoring                                                                                                                  599
Query Analyzer                                                                                                          605
Further Information                                                                                                  608
Conclusion                                                                                                                      609
17. Managing MySQL Replication with MySQL Utilities. . . . . . . . . . . . . . . . . . . . . . . . . . . . .  611
Common MySQL Replication Tasks                                                                           612
Checking Status                                                                                                          612
Stopping Replication                                                                                                 615
Adding Slaves                                                                                                              617
MySQL Utilities                                                                                                              618
Getting Started                                                                                                            618
Using the Utilities Without Workbench                                                                 619
Using the Utilities via Workbench                                                                           619
General Utilities                                                                                                             621
Comparing Databases for Consistency: mysqldbcompare                                  621
Copying Databases: mysqldbcopy                                                                           624
Exporting Databases: mysqldbexport                                                                      625
Importing Databases: mysqldbimport                                                                    628
Discovering Differences: mysqldiff                                                                         629
Showing Disk Usage: mysqldiskusage                                                                     632
Checking Tables Indexes: mysqlindexcheck                                                          635
Searching Metadata: mysqlmetagrep                                                                       636
Searching for Processes: mysqlprocgrep                                                                 637
Cloning Servers: mysqlserverclone                                                                         639
Showing Server Information: mysqlserverinfo                                                      641
Cloning Users: mysqluserclone                                                                                642
Utilities Client: mysqluc                                                                                            643
Replication Utilities                                                                                                       644
Setting Up Replication: mysqlreplicate                                                                   644
Checking Replication Setup: mysqlrplcheck                                                          646
Showing Topologies: mysqlrplshow                                                                        648
High Availability Utilities                                                                                             650
Concepts                                                                                                                      650
mysqlrpladmin                                                                                                            651
mysqlfailover                                                                                                               655
Creating Your Own Utilities                                                                                         663
Architecture of MySQL Utilities                                                                              663
xii 
| 
Table of Contents

### Page 15

Custom Utility Example                                                                                            664
Conclusion                                                                                                                      673
A. Replication Tips and Tricks. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  675
B. A GTID Implementation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  693
Index. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  705
Table of Contents 
| 
xiii

### Page 17

Foreword for the Second Edition
In 2011, Pinterest started growing. Some say we grew faster than any other startup to
date. In the earliest days, we were up against a new scalability bottleneck every day that
could slow down the site or bring it down altogether. We remember having our laptops
with us everywhere. We slept with them, we ate with them, we went on vacation with
them. We even named them. We have the sound of the SMS outage alerts imprinted in
our brains.
When the infrastructure is constantly being pushed to its limits, you can’t help but wish
for an easy way out. During our growth, we tried no less than five well-known database
technologies that claimed to solve all our problems, but each failed catastrophically.
Except MySQL. The time came around September 2011 to throw all the cards in the air
and let them resettle. We re-architected everything around MySQL, Memcache, and
Redis with just three engineers.
MySQL? Why MySQL? We laid out our biggest concerns with any technology and
started asking the same questions for each. Here’s how MySQL shaped up:
• Does it address our storage needs? Yes, we needed mappings, indexes, sorting, and
blob storage, all available in MySQL.
• Is it commonly used? Can you hire somebody for it? MySQL is one of the most
common database choices in production today. It’s so easy to hire people who have
used MySQL that we could walk outside in Palo Alto and yell out for a MySQL
engineer and a few would come up. Not kidding.
• Is the community active? Very active. There are great books available and a strong
online community.
• How robust is it to failure? Very robust! We’ve ne