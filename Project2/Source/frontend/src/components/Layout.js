import { Outlet } from "react-router-dom";
import Navbar from "./Navbar";
import { loadingContext } from "../Contexts";
import { useContext } from "react";

const Layout = () => {
	const isLoading = useContext(loadingContext);
	return (
		<div className="min-vh-100">
			{isLoading ? (
				<div
					className="w-100 vh-100 position-absolute d-flex justify-content-center bg-light"
					style={{
						zIndex: 1081,
					}}
				>
					<div
						className="spinner-border"
						role="status"
						style={{
							margin: "auto",
							width: "7rem",
							height: "7rem",
						}}
					>
						<span className="visually-hidden">Loading...</span>
					</div>
				</div>
			) : (
				<></>
			)}
			<Navbar />
			<div className="container">
				<Outlet />
			</div>
		</div>
	);
};

export default Layout;
