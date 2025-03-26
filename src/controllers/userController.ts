import { Request, Response } from "express";
import { AppDataSource } from "../main";
import { User } from "../entities/User";

const getRepositorySafely = async () => {
  if (!AppDataSource.isInitialized) {
    await AppDataSource.initialize();
  }
  return AppDataSource.getRepository(User);
};

export const getUsers = async (_req: Request, res: Response): Promise<void> => {
  const userRepository = await getRepositorySafely();
  const users = await userRepository.find();
  res.json(users);
};

export const getUser = async (req: Request, res: Response): Promise<void> => {
  const userRepository = await getRepositorySafely();
  const user = await userRepository.findOneBy({ id: parseInt(req.params.id) });
  if (!user) {
    res.status(404).json({ message: "User not found" });
    return;
  }
  res.json(user);
};

export const createUser = async (req: Request, res: Response): Promise<void> => {
  const userRepository = await getRepositorySafely();
  const user = userRepository.create(req.body);
  const savedUser = await userRepository.save(user);
  res.json(savedUser);
};

export const updateUser = async (req: Request, res: Response): Promise<void> => {
  const userRepository = await getRepositorySafely();
  const user = await userRepository.findOneBy({ id: parseInt(req.params.id) });
  if (!user) {
    res.status(404).json({ message: "User not found" });
    return;
  }
  userRepository.merge(user, req.body);
  const updatedUser = await userRepository.save(user);
  res.json(updatedUser);
};

export const deleteUser = async (req: Request, res: Response): Promise<void> => {
  const userRepository = await getRepositorySafely();
  const result = await userRepository.delete(req.params.id);
  res.json(result);
};