const express = require('express');
const bodyParser = require('body-parser');
const courseRouter = require('./routes/course');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

app.use('/course-access', courseRouter);

app.listen(PORT, () => {
  console.log(`OPA Secure Learning Platform server is running on http://localhost:${PORT}`);
});
