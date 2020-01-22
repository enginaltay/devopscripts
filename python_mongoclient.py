import pymongo

#Connect to MongoDB endpoint 
mdb_client = pymongo.MongoClient("mongodb://localhost:27017/")
my_db = mdb_client["files_db"] 
print (my_db)

#List all databases
print (mdb_client.list_database_names())

#Print specific db if exists
db_list = mdb_client.list_database_names()
if "files_db" in db_list:
	print("The DB exists.")

#Create a collection
my_col = my_db["symbols"]

#List collections
print (my_db.list_collection_names())

#Insert a record
my_dict = { "name": "Ngin", "address": "Istanbul" }
x = my_col.insert_one(my_dict)

#Insert multiple documents

my_list = [
	{ "name": "Amy", "address": "Miami st 652"},
	{ "name": "Vicky", "address": "Central st 98"},
	{ "name": "Richard", "address": "Main Road"},
	{ "name": "Johnny", "address": "Valley st 345"}
]
x = my_col.insert_many(my_list)
print(x.inserted_ids)