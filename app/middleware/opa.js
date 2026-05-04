const axios = require('axios');

const checkOPA = async (req, res, next) => {
  if (!req.body.role || !req.body.action) {
    return res.status(400).json({ error: "Invalid input: role and action are required" });
  }

  try {
    // Health check before policy call
    await axios.get('http://localhost:8181/health');

    const response = await axios.post(
      'http://localhost:8181/v1/data/auth/allow',
      { input: req.body }
    );

    if (response.data.result === true) {
      next();
    } else {
      res.status(403).json({ error: 'Access Denied' });
    }
  } catch (err) {
    res.status(500).json({ error: 'OPA Error', details: err.message });
  }
};

module.exports = checkOPA;
