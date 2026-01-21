package it.univaq.webengineering.soccorsoweb.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
@RequestMapping("/operatore")
public class OperatoreController {

   /* @GetMapping("/profilo/{id}")
    public String profilo(Model model,  @PathVariable Integer id) {
        model.addAttribute("nome", "id.get nome");
        return "profilo_operatore";
    }*/

    @GetMapping("/profilo")
    public String profilo(Model model) {
        model.addAttribute("nome", "Miriam");
        return "profilo_operatore";
    }

}
