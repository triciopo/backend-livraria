package edu.fateczl.book.Service;

import edu.fateczl.book.Repository.LivroRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LivroService {

    private final LivroRepository livroRepository;

    public  LivroService(LivroRepository livroRepository) {
        this.livroRepository = livroRepository;
    }

    public List<Map<String, Object>> gerarRelatorioPorCategoria(Long categoriaId) {
        List<Object[]> resultados = livroRepository.relatorioLivrosPorCategoria(categoriaId);
        List<Map<String, Object>> relatorio = new ArrayList<>();

        for (Object[] row : resultados) {
            Map<String, Object> livro = new HashMap<>();
            livro.put("titulo", row[0]);
            livro.put("categoria", row[1]);
            livro.put("preco", row[2]);
            relatorio.add(livro);
        }

        return relatorio;
    }
}
