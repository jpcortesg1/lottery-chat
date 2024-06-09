import express from "express"

// Crete app
const app = express()

// Use middleware
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// Get port
const port = process.env.PORT || 8000
app.set("port", port)

// Export app
export default app
