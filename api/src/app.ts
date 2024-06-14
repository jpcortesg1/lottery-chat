import express from "express"
import router from "./routes/index.routes"

// Crete app
const app = express()

// Use middleware
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// Prove that app is working
app.get("/api/v1", (req, res) => {
  return res.json({
    message: "The API is working!",
    status: "success",
  }).status(200)
})

// Use routes
app.use("/api/v1", router)

// Get port
const port = process.env.PORT || 8000
app.set("port", port)

// Export app
export default app
