import mongoose from "mongoose"

const connectDb=async ()=>{
    try {
       await mongoose.connect(process.env.BILLING_MONGODB_URI || process.env.MONGODB_URI) 
       console.log("db connected")
    } catch (error) {
       console.log(`db error ${error}`) 
    }
}

export default connectDb