package edu.fateczl.book.Repository;

import edu.fateczl.book.Models.Livro;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LivroRepository extends CrudRepository<Livro, Long> {
    Iterable<Livro> getAllByTitulo(String titulo);

    Object getById(Long id);

    Iterable<Livro> getAllByTituloContainsIgnoreCase(String titulo);

    @Query("SELECT l.titulo AS livro, l.categoria.nome AS categoria, l.preco AS preco FROM Livro l WHERE l.categoria.id = :categoriaId")
    List<Object[]> relatorioLivrosPorCategoria(@Param("categoriaId") Long categoriaId);
}
