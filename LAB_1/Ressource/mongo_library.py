from pymongo import MongoClient
from robot.api.deco import keyword, library
from bson.objectid import ObjectId

@library
class MongoLibrary:
    def __init__(self):
        self.client = None
        self.db = None

    @keyword
    def connect_to_mongo(self, uri, db_name):
        try:
            self.client = MongoClient(uri, serverSelectionTimeoutMS=5000)
            self.db = self.client[db_name]
            self.client.admin.command('ping')
            print("[MongoLibrary] Connexion MongoDB réussie.")
        except Exception as e:
            print(f"[MongoLibrary] Erreur de connexion MongoDB : {e}")
            self.client = None
            self.db = None
            raise RuntimeError(f"Impossible de se connecter à MongoDB : {e}")

    @keyword
    def disconnect_from_mongo(self):
        if self.client is not None:
            self.client.close()
            print("[MongoLibrary] Déconnexion MongoDB réussie.")
            self.client = None
            self.db = None

    def _validate_fields(self, document, collection, is_update=False):
        if collection == "products":
            if not is_update:
                if 'title' not in document or not document['title']:
                    raise ValueError("Le champ 'title' est requis.")
            if 'price' in document:
                try:
                    price = float(document['price'])
                    if price < 0:
                        raise ValueError("Le prix ne peut pas être négatif.")
                except (ValueError, TypeError):
                    raise ValueError("Le prix doit être un nombre valide.")
        elif collection == "users":
            if not is_update:
                for field in ['email', 'username', 'password']:
                    if field not in document or not document[field]:
                        raise ValueError(f"Le champ '{field}' est requis.")
        elif collection == "orders":
            if not is_update:
                if 'userId' not in document or not document['userId']:
                    raise ValueError("Le champ 'userId' est requis.")
                if 'products' not in document or not isinstance(document['products'], list) or len(document['products']) == 0:
                    raise ValueError("La liste 'products' doit être non vide.")
            if 'products' in document and (not isinstance(document['products'], list) or len(document['products']) == 0):
                raise ValueError("La liste 'products' doit être non vide.")

    @keyword
    def insert_document(self, collection, document):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        self._validate_fields(document, collection)
        col = self.db[collection]
        result = col.insert_one(document)
        return str(result.inserted_id)

    @keyword
    def find_documents(self, collection):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        col = self.db[collection]
        results = list(col.find())
        for doc in results:
            doc['_id'] = str(doc['_id'])
        return results

    @keyword
    def update_document(self, collection, query, new_values):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        if not query:
            raise ValueError("La requête ne peut pas être vide.")
        
        # Validation spécifique pour users : téléphone ne peut pas être vide
        if collection == "users":
            if 'phone' in new_values:
                phone = new_values['phone']
                if phone is None or phone == "":
                    raise ValueError("Le champ 'phone' ne peut pas être vide.")
        
        self._validate_fields(new_values, collection, is_update=True)
        
        col = self.db[collection]
        # Convert _id string to ObjectId dans query si présent
        if '_id' in query and isinstance(query['_id'], str):
            try:
                query['_id'] = ObjectId(query['_id'])
            except Exception:
                pass
        result = col.update_one(query, {"$set": new_values})
        return result.modified_count

    @keyword
    def delete_document(self, collection, query):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        if not query:
            raise ValueError("La requête de suppression ne peut pas être vide.")
        col = self.db[collection]
        # Convert _id string to ObjectId dans query si présent
        if '_id' in query and isinstance(query['_id'], str):
            try:
                query['_id'] = ObjectId(query['_id'])
            except Exception:
                pass
        result = col.delete_one(query)
        return result.deleted_count

    @keyword
    def creer_commande(self, user_id, produits, date=None):
        if not user_id:
            raise ValueError("Le champ 'userId' est requis.")
        if not produits or not isinstance(produits, list) or len(produits) == 0:
            raise ValueError("La liste 'products' doit être non vide.")
        document = {
            "userId": user_id,
            "products": produits
        }
        if date:
            document["date"] = date
        return self.insert_document("orders", document)

    @keyword
    def lire_commandes(self):
        return self.find_documents("orders")

    @keyword
    def lire_commandes_par_date(self, date):
        if not date:
            raise ValueError("La date est requise.")
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        col = self.db["orders"]
        result = list(col.find({"date": date}))
        for doc in result:
            doc["_id"] = str(doc["_id"])
        return result

    @keyword
    def mettre_a_jour_quantite_produit(self, commande_id, index_produit, nouvelle_quantite):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        if not ObjectId.is_valid(commande_id):
            raise ValueError("ID de commande invalide.")
        if not isinstance(nouvelle_quantite, int) or nouvelle_quantite < 0:
            raise ValueError("La quantité doit être un entier positif.")
        col = self.db["orders"]
        commande = col.find_one({"_id": ObjectId(commande_id)})
        if not commande:
            raise ValueError("Commande introuvable.")
        produits = commande.get("products", [])
        if index_produit < 0 or index_produit >= len(produits):
            raise IndexError("Index de produit invalide.")
        produits[index_produit]["quantite"] = nouvelle_quantite
        result = col.update_one({"_id": ObjectId(commande_id)}, {"$set": {"products": produits}})
        return result.modified_count

    @keyword
    def supprimer_commande(self, commande_id):
        if self.db is None:
            raise RuntimeError("Connexion MongoDB non établie.")
        if not ObjectId.is_valid(commande_id):
            raise ValueError("ID de commande invalide.")
        col = self.db["orders"]
        result = col.delete_one({"_id": ObjectId(commande_id)})
        return result.deleted_count
