## Vigenère Cipher in MASM 
Resources Online: [https://www.geeksforgeeks.org/vigenere-cipher/
](https://www.geeksforgeeks.org/vigenere-cipher/)

Website of demo: [https://studio.code.org/s/vigenere/lessons/1/levels/1](https://studio.code.org/s/vigenere/lessons/1/levels/1)

## Notes
Encryption
The plaintext(P) and key(K) are added modulo 26.
Ei = (Pi + Ki) mod 26

Decryption
Di = (Ei - Ki) mod 26

Lowercase to uppercase
Lowercase - 32


When dividing the number in assembly language, the remainder will be stored in edx in which we will add 65 because that’s where the alphabets begin in ASCII code and we are using 0 index for numbers against alphabets.
Like 18 represents S but if we print it using write char it won’t print but if we add 65 to it that’s where the alphabets begin in ASCII code we get S.
Then we also have to subtract 65 before comparing, that where it is greater and equal to 26 or not.

For incrementing the key word to match the length of cipher or plain text
The equation = ( esi + 1 ) % (size of key)
Here esi, will be pointing to the current current character of key 

![Cipher Table](https://github.com/humayyuntariq/Vigenere-Cipher-COAL/assets/85873694/7b705cba-018c-4971-8907-dbcc16c093e9)


