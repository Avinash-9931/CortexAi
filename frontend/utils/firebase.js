// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider} from "firebase/auth";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY ,
  authDomain: "cortexorgai.firebaseapp.com",
  projectId: "cortexorgai",
  storageBucket: "cortexorgai.firebasestorage.app",
  messagingSenderId: "449664233685",
  appId: "1:449664233685:web:be93782b842efde49df25c"
};
// Initialize Firebase
const app = initializeApp(firebaseConfig)
export const auth=getAuth(app)
export const googleProvider=new GoogleAuthProvider()