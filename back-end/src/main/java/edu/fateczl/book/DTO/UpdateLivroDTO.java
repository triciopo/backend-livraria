package edu.fateczl.book.DTO;

public record UpdateLivroDTO(String titulo, int anoPublicacao, double preco,
                             int estoque, String descricao, long autorId, long categoriaId) {
}
