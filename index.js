const express = require('express');
const mysql = require('mysql');
const morgan = require('morgan');
const cors = require('cors');
const bodyParser = require('body-parser');
const routes = require('./config/routes.js');

const app = express();
const conexao = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'intuitive'
});

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(express.json());
app.use(cors());
app.use(routes);

app.use(express.static('public'));
conexao.connect(
    (erro) => {
        if (erro) {
            console.log('Erro ao conectar:');
            console.log(erro);
        } else {
            console.log('Conexão realizada com sucesso!');
        }
    }
);

app.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
})