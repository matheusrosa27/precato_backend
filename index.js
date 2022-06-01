const express = require('express');
const mysql = require('mysql');
const morgan = require('morgan');
const cors = require('cors');
const bodyParser = require('body-parser');
const routes = require('./config/routes.js');

const app = express();

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(express.json());
app.use(cors());
app.use(routes);

app.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
})