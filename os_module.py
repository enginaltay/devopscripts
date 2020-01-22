import os,platform

# print(os.name)
# print(os.getcwd()) #get current working directory
# print(platform.system()) #get operating system
# print(platform.release())
print(os.uname())

try: 
    #If the file does not exist it will throw an IOError 
    filename = 'OS.txt'
    f = open(filename, 'rU') 
    text = f.read() 
    f.close() 
#Jumps directly to here if any of the above lines throws IOError.     
except IOError: 
    print('Problem reading: ' + filename) 
