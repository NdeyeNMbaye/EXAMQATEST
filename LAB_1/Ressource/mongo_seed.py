from pymongo import MongoClient

def seed_data(uri, db_name):
    client = MongoClient(uri)
    db = client[db_name]

    # Supprime l'existant
    db.products.delete_many({})
    db.users.delete_many({})
    db.orders.delete_many({})
    db.categories.delete_many({})

    products = [
        {"title": "Sac Fjallraven", "price": 109.95, "description": "Sac robuste", "category": "men's clothing", "image": "https://fakestoreapi.com/img/image1.jpg"},
        {"title": "Montre Vintage", "price": 59.99, "description": "Montre élégante", "category": "accessories", "image": "https://fakestoreapi.com/img/image2.jpg"},
        {"title": "Chaussures Sport", "price": 79.99, "description": "Confort max", "category": "men's shoes", "image": "https://fakestoreapi.com/img/image3.jpg"},
        {"title": "T-shirt Casual", "price": 25.0, "description": "T-shirt pour tous", "category": "men's clothing", "image": "https://fakestoreapi.com/img/image4.jpg"},
        {"title": "Jeans Slim", "price": 45.5, "description": "Jeans moderne", "category": "men's clothing", "image": "https://fakestoreapi.com/img/image5.jpg"},
    ]
    db.products.insert_many(products)

    users = [
        {"email": "john@gmail.com", "username": "johnd", "password": "hashed1", "name": {"firstname": "John", "lastname": "Doe"}, "address": {"city": "Dakar", "street": "123 rue", "zipcode": "00000", "geolocation": {"lat": "-14.7", "long": "17.4"}}, "phone": "77-123-4567"},
        {"email": "alice@gmail.com", "username": "alicew", "password": "hashed2", "name": {"firstname": "Alice", "lastname": "Wonder"}, "address": {"city": "Ziguinchor", "street": "456 avenue", "zipcode": "11111", "geolocation": {"lat": "-15.0", "long": "16.0"}}, "phone": "77-765-4321"},
        {"email": "bob@gmail.com", "username": "bobb", "password": "hashed3", "name": {"firstname": "Bob", "lastname": "Builder"}, "address": {"city": "Thiès", "street": "789 boulevard", "zipcode": "22222", "geolocation": {"lat": "-14.9", "long": "17.0"}}, "phone": "77-555-1234"},
        {"email": "eve@gmail.com", "username": "evea", "password": "hashed4", "name": {"firstname": "Eve", "lastname": "Adam"}, "address": {"city": "Kaolack", "street": "321 route", "zipcode": "33333", "geolocation": {"lat": "-14.8", "long": "17.1"}}, "phone": "77-888-9999"},
        {"email": "mike@gmail.com", "username": "mikez", "password": "hashed5", "name": {"firstname": "Mike", "lastname": "Z"}, "address": {"city": "Saint-Louis", "street": "654 chemin", "zipcode": "44444", "geolocation": {"lat": "-14.6", "long": "17.2"}}, "phone": "77-222-3333"},
    ]
    db.users.insert_many(users)

    product_ids = list(db.products.find({}, {"_id": 1}))
    user_ids = list(db.users.find({}, {"_id": 1}))
    orders = []
    for i in range(5):
        orders.append({
            "userId": user_ids[i]["_id"],
            "date": "2020-03-0{}T00:00:00.000Z".format(i+1),
            "products": [
                {"productId": product_ids[i]["_id"], "quantity": i+1},
                {"productId": product_ids[(i+1)%5]["_id"], "quantity": (i+2)}
            ]
        })
    db.orders.insert_many(orders)

    categories = [
        {"name": "men's clothing", "description": "Articles destinés aux hommes", "image": "https://fakestoreapi.com/img/cat1.jpg"},
        {"name": "women's clothing", "description": "Articles destinés aux femmes", "image": "https://fakestoreapi.com/img/cat2.jpg"},
        {"name": "jewelery", "description": "Bijoux divers", "image": "https://fakestoreapi.com/img/cat3.jpg"},
        {"name": "electronics", "description": "Appareils électroniques", "image": "https://fakestoreapi.com/img/cat4.jpg"},
        {"name": "accessories", "description": "Accessoires variés", "image": "https://fakestoreapi.com/img/cat5.jpg"},
    ]
    db.categories.insert_many(categories)

    print("Données insérées avec succès.")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("Usage: python mongo_seed.py <mongo_uri> <db_name>")
    else:
        seed_data(sys.argv[1], sys.argv[2])
