// The User store. Tracks which user is currently signed
// in.

import { defineStore } from "pinia";
import { mande } from "mande";

// This isn't great, it should be an environment variable but it will do for development/where BE/FE are tied together
export const userApi = mande("http://localhost:3030/api/users");

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
