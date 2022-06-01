const express = require('express');
const routes = express.Router();

let db = [
    { '1': { Nome: 'Cliente 1', Idade: '20' } },
    { '2': { Nome: 'Cliente 2', Idade: '19' } },
    { '3': { Nome: 'Cliente 3', Idade: '18' } },
]

// Busca de Dados
routes.get("/",(req,res) => {
    return res.json(db);
});

// Inserir Dados
routes.post("/add",(req, res) => {
    const body = req.body;

    if (!body) {
        return res.send(400).end();
    }

    db.push(body);
    return res.json(body);
})

// Deletar Dados
routes.delete('/:id', (req, res) => {
    const id = req.params.id;

    let newDb = db.filter(item => {
        if (!item[id]){
            return item
        }
    })

    db = newDb;

    return res.send(newDb);
})

module.exports = routes;