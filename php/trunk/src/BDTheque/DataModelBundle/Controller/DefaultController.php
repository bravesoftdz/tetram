<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DefaultController extends Controller {

    public function indexAction($name = null) {
        return $this->render('BDThequeDataModelBundle:Default:index.html.twig', array('name' => $name));
    }

}

?>