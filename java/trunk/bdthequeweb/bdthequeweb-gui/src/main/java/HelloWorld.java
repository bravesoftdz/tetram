import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

@ManagedBean
@SessionScoped
public class HelloWorld {
	public String getGreetings() {
		return "hello";
	}
}
