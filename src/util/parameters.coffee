ensure = (req, res, parameters...) ->
  for p in parameters
    if !req.query[p]?
      res.status(400).send("Parameter #{p} is required")
      return false
  true


module.exports = {ensure}
