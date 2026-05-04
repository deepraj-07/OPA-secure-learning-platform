const express = require('express');
const checkOPA = require('../middleware/opa');

const router = express.Router();

router.post('/', checkOPA, (req, res) => {
  res.json({ message: 'Access Granted' });
});

module.exports = router;
