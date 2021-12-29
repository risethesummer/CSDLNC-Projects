import { useContext } from "react";
import { Container, Navbar as BNavbar } from "react-bootstrap";
import { Link } from "react-router-dom";
import { loginContext } from "../Contexts";

const Navbar = () => {
	const isAuthenticated = useContext(loginContext);
	return (
		<>
			<BNavbar bg="light">
				<Container>
					<BNavbar.Brand href="#">Group 8</BNavbar.Brand>
					{isAuthenticated ? (
						<div>
							<Link className="m-2" to="/">Product</Link>
							<Link className="m-2" to="/cart">Cart</Link>
							<Link className="m-2" to="/orders">Orders</Link>
							<Link className="m-2" to="/logout">Logout</Link>
						</div>
					) : (
						<></>
					)}
				</Container>
			</BNavbar>
		</>
	);
};

export default Navbar;
