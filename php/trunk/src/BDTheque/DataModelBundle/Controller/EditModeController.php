<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;

class EditModeController extends Controller {

    /**
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function indexAction() {

        return $this->render('BDThequeDataModelBundle::editMode.layout.html.twig');
    }


}