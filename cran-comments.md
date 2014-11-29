R CMD CHECK passed on my local OS X install on R 3.1.2 and R development
version, Ubuntu running on Travis-CI, and a Windows machine running on
Appveyor (Win-Builder has been down so I haven't been able to test
against it).

I have read and agree to the the CRAN policies at
http://cran.r-project.org/web/packages/policies.html

I fixed a few things from my first submission on 2014-11-25:
- Period removed from end of the package title in DESCRIPTION file.
- Examples all in \donttest now, except a few.

Thanks! Scott Chamberlain
