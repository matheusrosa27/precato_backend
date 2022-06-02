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
    conexao.query("SELECT * FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message",
    (erro,resultado) => {
        if(erro) {
            console.log(erro);
            res.send("Error");
        } else {
            res.send(resultado);
        }
    });

    /*
    conexao.query("DELETE FROM dados WHERE registro_ans=?", [reg_ans],
    (erro,resultado) => {
        if(erro) {
            console.log(erro);
            res.status(500).send(erro);
            res.send("Deu erro");
        } else {
            res.send(resultado);
        }
    });
    */
})

// Create Subscription
router.post("/add",(req, res) => {
    const name = req.body.name;

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
})


module.exports = router;