import { useContext, useEffect } from "react";
import { useNavigate, Outlet } from "react-router-dom";
import { loginContext } from "../Contexts";

function ProtectedRoute() {
	const isAuthenticated = useContext(loginContext);
	const navigate = useNavigate();

	useEffect(() => {
		if (!isAuthenticated) navigate("/login", { replace: true });
	}, [isAuthenticated]);

	return <Outlet />;
}

export default ProtectedRoute;
