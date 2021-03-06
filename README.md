spq
===

  Script written in Perl, which allows all the basic formulas and equations for classical theoretical physics.
  
# NAME

abcd.pl - Solves the physical formula based on a set of input physical quantities

abcd_wiki.pl - Hash function to redirect references to physical quantities in wikipedia

# SUPPORT

You can financially support the project by either:

1. A direct donation BTC: [1PUdynE6supgJAAcDmiYupeU6Gv6F6k94A](https://blockchain.info/address/1PUdynE6supgJAAcDmiYupeU6Gv6F6k94A)
2. A direct donation Ripple: [rLaTKSx5Zqcvjrchdeqd2tkSyTVm7jeJmK](https://ripple.com/graph/#rLaTKSx5Zqcvjrchdeqd2tkSyTVm7jeJmK)
3. A direct donation Primecoin: [AeV3uUMAZqH34PNYnvtkqjebP25YgZgV3f](https://coinplorer.com/XPM/Addresses/AeV3uUMAZqH34PNYnvtkqjebP25YgZgV3f)
4. Tip4Commit: https://tip4commit.com/projects/946

[![tip for next commit](https://tip4commit.com/projects/946.svg)](https://tip4commit.com/github/Ignat99/spq)
[![tip for next commit](http://prime4commit.com/projects/71.svg)](http://prime4commit.com/projects/71)
 - Code committed to the project is rewarded with bitcoin (BTC) and primecoin (XPM)



# DESCRIPTION

abcd.pl - CGI sсript, written in the [Perl programming language](http://www.perl.org/) 
from [24/08/2006](https://groups.google.com/forum/#!topic/ignat/tqxhS3aDSXM).

Its primary goal is to demonstrate the principle of withdrawal of simple 
equations of theoretical physics. Script displays the System of physical quantities 
of Plotnikov N. A. (SPQ) and clearly highlights the operators and the dependency chain.

[Video from YAPC::Europe 2014](https://www.youtube.com/watch?v=cTP9A-3OJyU) 

# NEWS

* To stay tuned follow on Twitter: [SPQ](http://twitter.com/ignat_99)
* Or [G+](https://plus.google.com/u/0/112645380138653339159/posts)
  
# VERSION

abcd.pl -  v.0.2.0

# SYNOPSIS

abcd.pl - Perl CGI sсript.
Available at http://127.0.0.1/cgi-bin/abcd.pl

# INSTALLATION

Сopy the files to a directory cgi-bin of your local web server.
  
    sudo cp cgi-bin/* /usr/lib/cgi-bin
  
Set the permissions of these files.
  
    sudo chown www-data:www-data /usr/lib/cgi-bin/abcd.pl
    sudo chown www-data:www-data /usr/lib/cgi-bin/abcd_wiki.pl

# EXAMPLES
Exhaustive documentation is still missing and current examples are basic. 

[Newton's second law](http://localhost/cgi-bin/abcd.pl?tpq=F&pq1=m&pq2=E)

[Speed ​​through space and time](http://localhost/cgi-bin/abcd.pl?tpq=v_s&pq1=T&pq2=l1)

[Ampère's force law](http://localhost/cgi-bin/abcd.pl?tpq=F&pq1=B&pq2=I&pq3=l1)

# DEPENDENCIES

abcd.pl and abcd_wiki.pl depends on the following modules
  
CGI - Handle Common Gateway Interface requests and responses.

Optional modules may be needed if you want to use some features (but are not required for a basic usage).

Dependency-checks for additional features are performed at runtime.

Most common modules you may want are:

Plugins for JS programming language
* (https://github.com/tokuhirom/node-perl)
* (http://linkedin.github.io/dustjs/)

Plugins for Python programming language
* (http://search.cpan.org/dist/Inline-Python/Python.pod)

May be later to operate asynchronously for Perl
* (https://github.com/kraih/minion)

# DOCUMENTATION

[Group System of physical quantities of Plotnikov N. A. (SPQ)](https://groups.google.com/forum/#!topic/ignat/tqxhS3aDSXM).

[Algorithm automated the simplest tasks of general physics](http://zornica.tk/ignat99.pdf)

# CONTRIBUTING

Of course anybody can contribute by reporting issues via github or fixing
typos in the documentation. To be able to contribute with code, some rules
need to be kept. This is mandatory for any community project. 

# REST API

While working out in beta version on the site [HomeDevice.pro](http://mc.homedevice.pro/)

# PLUGINS

Planned to connect several ready plugins for node.js programming language.

# CONTINUOUS INTEGRATION

We would like to know that our software is always in good health so we
count on friendly developers and organizations to install and test it
continuously.

# SECURITY CONSIDERATIONS

Script to suit only for local use for security reasons.
  
Local scripts are executed with only few necessary environment variables 
(others are removed), but otherwise have the same privileges and access to 
system resources as the user, who started the browser. However, downloading 
locally executed scripts from remote locations or using Perl, Python or PHP 
interpreters as helper applications for online content are not going to be 
implemented because of the huge security risks involved! It is also not a 
good idea to make any folders containing locally executed scripts available 
to web servers or file sharing applications due to the risk of executing 
locally malicious or unsecure code uploaded from outside. 

# HISTORY

abcd.pl was started as a simple GUI CGI script for personal databases of 
System of physical quantities. This small project (965 lines of code) is 
still in its very beginning and current version (0.2.0) should be considered 
beta pre-release. Do not use it for production purposes! 
   
# SEE ALSO

[Diakoptics](https://en.wikipedia.org/wiki/Diakoptics)

# AUTHORS

Authors in order of joining the core team.

[Николай Александрович Плотников](http://vologda-travel.ru/celebs/plotnikov-nikolay-aleksandrovich.htm) (Nikolai Plotnikov)

Игнат Игнатов (Ignat Ignatov)(ignat99@gmail.con)

Макс Жигулин (Max Zhegulin)(max.zhegulin@gmail(dot)com)

Villa Zornica, the hackerspace of Chepelare (http://zornica.tk/). 

# COPYRIGHT AND LICENSE

Copyright 2006-2014 Ignat Ignatov.

This program is free software, you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License v3 (LGPL-3.0).
You may copy, distribute and modify the software provided that
modifications are open source. However, software that includes the license
may release under a different license.

See http://opensource.org/licenses/lgpl-3.0.html for more information.

