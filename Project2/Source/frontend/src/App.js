import "./App.scss";
import Login from "./views/Login";
import Signup from "./views/Signup";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import ListingProducts from "./views/ListingProducts";
import ListingProductsInCart from "./views/ListingProductsInCart";

import { loginContext, loadingContext, userContext } from "./Contexts";
import { useState, useMemo } from "react";
import { Routes, Route, BrowserRouter } from "react-router-dom";
import Logout from "./views/Logout";
import ListingOrders from "./views/ListingOrders";

function App() {
	const [isAuthenticatedInState, setAuthenticated] = useState(false);
	const [isLoadingInState, setLoadingInState] = useState(false);
	const [user, setUser] = useState({});

	const memoIsAuthenticated = useMemo(
		() => isAuthenticatedInState,
		[isAuthenticatedInState]
	);

	const memoIsLoading = useMemo(() => isLoadingInState, [isLoadingInState]);
	const memoUser = useMemo(() => user, [user]);

	const defaultProps = useMemo(
		() => ({
			setLoading: setLoadingInState,
		}),
		[memoIsAuthenticated, memoIsLoading]
	);

	return (
		<loadingContext.Provider value={memoIsLoading}>
			<loginContext.Provider value={memoIsAuthenticated}>
				<userContext.Provider value={memoUser}>
					<BrowserRouter>
						<Routes>
							<Route
								path="/"
								element={<Layout {...defaultProps} />}
							>
								<Route
									path="login"
									element={
										<Login
											setAuthenticated={setAuthenticated}
											setUser={setUser}
											{...defaultProps}
										/>
									}
								/>
								<Route
									path="signup"
									element={<Signup {...defaultProps} />}
								/>
								<Route
									path="/"
									element={
										<ProtectedRoute {...defaultProps} />
									}
								>
									<Route
										index
										element={
											<ListingProducts
												{...defaultProps}
											/>
										}
									/>
									<Route
										path="cart"
										element={
											<ListingProductsInCart
												{...defaultProps}
											/>
										}
									/>
									<Route
										path="logout"
										element={
											<Logout
												{...defaultProps}
												setAuthenticated={
													setAuthenticated
												}
												setUser={setUser}
											/>
										}
									/>
									<Route
										path="orders"
										element={<ListingOrders {...defaultProps} />}
									/>
								</Route>
							</Route>
						</Routes>
					</BrowserRouter>
				</userContext.Provider>
			</loginContext.Provider>
		</loadingContext.Provider>
	);
}

export default App;
