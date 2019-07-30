#!/usr/bin/env python3

import requests as r
import re

f = open("data.clp")

content = f.read()
found = re.finditer(r'locality\n\s+\(name "(\w+)"\)', content)
to_write=[]
for i in found:
    response = r.get("https://www.google.com/maps/place/"+i.group(1))
    res = re.search(r'(\d+\.\d+)%2C(\d+\.\d+)', response.text) #cerca coordinate
    to_write.append("\t(position\n\t\t(name \""+i.group(1)+"\")\n\t\t(latitude "+res.group(1)+")\n\t\t(longitude "+res.group(2)+")\n)")
print("\n".join(to_write))