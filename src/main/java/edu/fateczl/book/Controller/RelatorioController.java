package edu.fateczl.book.Controller;

import edu.fateczl.book.Service.LivroService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/relatorio")
public class RelatorioController {
    private final LivroService livroService;

    public RelatorioController(LivroService livroService) {
        this.livroService = livroService;
    }

    @GetMapping("/categoria/{id}/livros")
    public List<Map<String, Object>> relatorioLivrosPorCategoria(@PathVariable Long id) {
        return livroService.gerarRelatorioPorCategoria(id);
    }
}
