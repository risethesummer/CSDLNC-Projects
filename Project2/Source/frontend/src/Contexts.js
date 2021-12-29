import { createContext } from "react";

export const API_URL = "https://127.0.0.1:5001"
export const loginContext = createContext(false);
export const userContext = createContext({});
export const loadingContext = createContext(false);