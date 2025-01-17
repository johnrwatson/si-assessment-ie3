// The User store. Tracks which user is currently signed
// in.

import { defineStore } from "pinia";
import { mande } from "mande";
import fetch from "isomorphic-fetch";

// In a production situation the dns name hosting the FE would be injected here instead of a reserved static ip
export const BASE_URL = process.env.NODE_ENV === "production" ? "http://35.247.107.51:3030" : "http://localhost:3030";
export const userApi = mande(BASE_URL + "/api/users", {}, fetch);

// The User type. Corresponds with a `User` on the backend.
export interface User {
  id: string;
  name: string;
}

// Will be 'null' if there is no user; otherwise will have the User
export interface UserState {
  user: User | null;
}

export const useUserStore = defineStore({
  id: "user",
  state: (): UserState => ({
    user: null,
  }),
  actions: {
    // Sign the user in with the backend.
    async signIn(name: string) {
      this.user = await userApi.post({ name });
    },
    // Clear the store, reset to its original state.
    clear() {
      this.user = null;
    },
  },
});
