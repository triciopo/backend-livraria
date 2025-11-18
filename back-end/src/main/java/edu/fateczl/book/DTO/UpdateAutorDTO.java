package edu.fateczl.book.DTO;

import java.time.LocalDate;

public record UpdateAutorDTO(String nome, String nacionalidade, LocalDate dataNascimento) {
}
