import csv
from collections import Counter

daten_liste = []
file = 'events.csv'

with open(file, 'r', encoding='utf-8') as file:
    reader = csv.reader(file)
    for row in reader:
        daten_liste.append(row)

print(daten_liste[1])
i = 0

ip_liste = []
for ip in daten_liste:
    ip_liste.append(ip[1])
    i += 1

zaehler = Counter(ip_liste)
haeufigste_ips = zaehler.most_common(3)
print(haeufigste_ips)
