const express = require('express');
const mysql = require('mysql');
const router = express.Router();


// Database connection
let conexao = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'precato'
});
router.use(express.static('public'));
conexao.connect(
    (erro) => {
        if (erro) {
            console.log('Error while connecting:');
            console.log(erro);
        } else {
            console.log('Connected!');
        }
    }
);


// Read
router.get('/', (req, res, next) => {
    conexao.query("SELECT subscriptions.id, subscription_date, name, last_message, active, message_flow.id, template_name, position FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message",
    (erro,resultado) => {
        if(erro) {
            console.log(erro);
            res.send("Error");
        } else {
            res.send(resultado);
        }
    });
})

// Create Subscription
router.post("/add",(req, res) => {
    const name = req.body.name;

    if(!name){
        res.status(400).send("Digite um email!");
    } else if (name.match(/.@...../i)){
        if (name.match(/.com/i)){
            conexao.query("INSERT INTO subscriptions (name) VALUES(?)", [name],
                (erro,resultado) => {
                    if(erro) {
                        console.log(erro);
                        res.status(500).send(erro);
                        res.send("Error");
                    } else {
                        res.send(resultado);
                    }
                });
        } else {
            res.status(400).send("Alguma informação está inválida!")
        }
    } else {
        res.status(400).send("Alguma informação está inválida!")
    }

    
})


module.exports = router;