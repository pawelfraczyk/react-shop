import express from "express";
import bodyParser from "body-parser";
import path from "path";
import dotenv from "dotenv";
import * as fs from 'fs';
import mongodb from "mongodb";
import unsafegames from "./routes/unsafegames";
import unsafepublishers from "./routes/unsafepublishers";
import games from "./routes/games";
import authgames from "./routes/authgames";
import users from "./routes/users";
import auth from "./routes/auth";
import cart from "./routes/cart";

dotenv.config({
  path: path.join(__dirname, ".env")
});
const app = express();

app.use((req, res, next) => {
  res.append('Access-Control-Allow-Origin', ['*']);
  res.append('Access-Control-Allow-Credentials', 'true');
  res.append(
    'Access-Control-Allow-Methods',
    'GET, POST, OPTIONS, PUT, PATCH, DELETE'
  );
  res.append(
    'Access-Control-Allow-Headers',
    'authorization, Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers'
  );
  next();
});

app.use("/static", express.static(path.join(__dirname, "static")));
app.use(bodyParser.json());

// routes
app.use("/api/unsafegames", unsafegames);
app.use("/api/unsafepublishers", unsafepublishers);
app.use("/api/games", games);
app.use("/api/authgames", authgames);
app.use("/api/users", users);
app.use("/api/auth", auth);
app.use("/api/cart", cart);

const {
  MONGO_USER,
  MONGO_PASS,
  MONGO_HOST,
  MONGO_PORT,
  MONGO_DB,
  MONGO_CONN_STRING
} = process.env;

//Specify the Amazon DocumentDB cert
var ca = [fs.readFileSync(__dirname + "/rds-combined-ca-bundle.pem")];

mongodb.MongoClient.connect(`mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_CONN_STRING}`,
  {
    sslValidate: true,
    sslCA: ca,
    useNewUrlParser: true
  },
  (err, client) => {
    if (err)
      throw err;
    
    const db = client.db(MONGO_DB)

    app.set("db", db);

    app.get("/*", (req, res) => {
      res.sendFile(path.join(__dirname, "./index.html"));
    });

    app.listen(2370, () => console.log("Running on localhost:2370"));
  });
