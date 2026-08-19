import hashlib

target = "38e835516233aab53c36b25f87604453d8b74f4c"
dateiname = "wordlist.txt"
liste_der_zeilen = []
suffix = "THWS"


with open(dateiname, 'r', encoding='utf-8') as datei:
    for zeile in datei:
        liste_der_zeilen.append(zeile.rstrip())



for zeile in liste_der_zeilen:
    passwort_with_suffix = zeile + suffix
    m = hashlib.sha1()
    m.update(passwort_with_suffix.encode('utf-8'))   #In Binaer umwandeln
    passwort_in_sha1 = m.hexdigest()
    if target == passwort_in_sha1:
        print(passwort_with_suffix)

