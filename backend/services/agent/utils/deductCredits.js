import axios from "axios"

export const deductCredits=async (userId,agent)=>{
    try {
       const {data}=await axios.post(`${process.env.AUTH_SERVICE || "http://127.0.0.1:8001"}/deduct-credits`,{userId,agent})
       return data
    } catch (error) {
        console.log(error)
        return null
    }
}