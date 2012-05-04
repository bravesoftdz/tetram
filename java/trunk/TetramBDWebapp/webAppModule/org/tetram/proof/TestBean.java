package org.tetram.proof;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.enterprise.context.SessionScoped;
import javax.inject.Named;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Named("testBean")
@SessionScoped
public class TestBean implements Serializable {
 
    @PersistenceContext(name = "JBossRegelPU")
    EntityManager em;
    private static final long serialVersionUID = -1625566649081574918L;
 
    public TestBean() {
    }
 
	public List<String> autocomplete(String prefix) {
        ArrayList<String> result = new ArrayList<String>();
        result.add("England");
        result.add("France");
        result.add("Germany");
        result.add("Italy");
        result.add("Spain");
 
        return result;
    }
 
}