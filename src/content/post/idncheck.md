+++
title = "IDNcheck: a tool for checking the threat level of internationalized domain names (IDNs)"
tags = [ "Development", "Python", "security", "domain names" ]
categories = [ "Development" ]
series = [ "Python" ]
slug = "idncheck"
project_url = "https://github.com/soulshake/idncheck"
#aliases = 
#summary = 
draft = "true"
#publishdate =
#url = 

+++

Here's an example of IDNcheck in action:

```
$ docker run -ti soulshake/idncheck paypаl
5
```

```
$ docker run -ti soulshake/idncheck paypal
1
```

See also Mark's excellent presentation on IDN exploits (warning: it may keep you up at night).
