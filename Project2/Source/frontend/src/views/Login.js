import { Form, Button } from "react-bootstrap";
import { API_URL, loginContext } from "../Contexts";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { useContext, useEffect } from "react";
import { Link } from "react-router-dom"

function Login({ setAuthenticated,setLoading, setUser }) {
	const isAuthenticated = useContext(loginContext)
	const navigate = useNavigate();

	useEffect(() => {
		if (isAuthenticated) navigate("/", { replace: true });
	}, [isAuthenticated])

	const onSubmit = (e) => {
		console.log()
		e.preventDefault();
		setLoading(true)
		axios
			.post(API_URL + "/user/signin", {
				userName: e.target[0].value,
				password: e.target[1].value,
			})
			.then((resp) => {
				setUser(resp.data)
				setAuthenticated(true);
				setLoading(false);
				alert("Successfully login !!");
			})
			.catch((_) => {
				setLoading(false);
				alert("Errors");
			});
	};

	return (
		<div className="container-fluid p-5 d-flex justify-content-center">
			<Form onSubmit={onSubmit} className="w-50">
				<Form.Group className="mb-3" controlId="formBasicEmail">
					<Form.Label>Username</Form.Label>
					<Form.Control
						type="username"
						placeholder="Enter username"
						required
					/>
				</Form.Group>

				<Form.Group className="mb-3" controlId="formBasicPassword">
					<Form.Label>Password</Form.Label>
					<Form.Control type="password" placeholder="Password" required />
				</Form.Group>
				<Button variant="primary" type="submit">
					Submit
				</Button>
				<Link to="/signup" className="m-2">or signup ?</Link>
			</Form>
		</div>
	);
}

export default Login;
